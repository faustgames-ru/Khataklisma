package engine.render;

import kha.Shaders;
import kha.Framebuffer;
import kha.Image;
import kha.Color;
import kha.arrays.Float32Array;
import kha.arrays.Uint32Array;
import kha.math.FastMatrix4;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.graphics4.PipelineState;
import kha.graphics4.CompareMode;
import kha.graphics4.CullMode;
import kha.graphics4.ConstantLocation;
import kha.graphics4.TextureUnit;
import kha.graphics4.BlendingOperation;
import kha.graphics4.BlendingFactor;
import haxe.ds.Vector;
import Std;

class RenderService implements IRenderService
{
	var _vb: VertexBuffer;
	var _ib: IndexBuffer;
	var _pipeline: PipelineState;
	var _transfomID: ConstantLocation;
	var _textureID: TextureUnit;
	var _indicesCount: Int;
	var _verticesCount: Int;
	var _structureLength: Int;
	var _transfom: FastMatrix4;	
	var _entries: List<RenderEntry>;

	var _vbCache: Float32Array;
	var _ibCache: Uint32Array;
	
	var _vLimit: Int = 1024*1024;
	var _iLimit: Int = 1024*1024;

	public function new()
	{

		var structure = new VertexStructure();
		structure.add('xy', VertexData.Float2);
		structure.add('uv', VertexData.Float2);
		_structureLength = 4;
		
		_vbCache = new Float32Array(_vLimit);
		_ibCache = new Uint32Array(_iLimit);

		_vb = new VertexBuffer(_vLimit, structure, Usage.DynamicUsage);

		_pipeline = new PipelineState();
		_pipeline.inputLayout = [structure];
		_pipeline.vertexShader = Shaders.painter_texture_vert;
		_pipeline.fragmentShader = Shaders.painter_texture_frag;
		_pipeline.depthWrite = false;
        _pipeline.depthMode = CompareMode.Always;
        _pipeline.cullMode = CullMode.None;
		
		_pipeline.blendOperation = BlendingOperation.Add;
		_pipeline.blendSource = BlendingFactor.SourceAlpha;
		_pipeline.blendDestination = BlendingFactor.InverseSourceAlpha;

		_pipeline.compile();
		_transfomID = _pipeline.getConstantLocation("projection");
		_textureID = _pipeline.getTextureUnit("tex");
		
		_ib = new IndexBuffer(_iLimit, Usage.DynamicUsage);
		
		_transfom = FastMatrix4.identity();
	 	_entries = new List<RenderEntry>();
	}

	public function begin(): Void
	{
		_entries.clear();
		_indicesCount = 0;
		_verticesCount = 0;
	}

	public function drawImage(texture: Image, vertices: Vector<Float>, indices: Vector<Int>, transform: Transform): Void
	{
		if (_entries.isEmpty())
		{
			_entries.add( new RenderEntry(_indicesCount, texture));
		}
		else
		{
			if ( _entries.last().Texture != texture)
			{
				_entries.add( new RenderEntry(_indicesCount, texture));
			}
		}
		var entry = _entries.last();
		
		if ((_verticesCount + vertices.length)*_structureLength > _vLimit) 
		{
			trace("vertex buffer oveflow");
			return;
		}

		if (_indicesCount + indices.length > _iLimit) 
		{
			trace("index buffer oveflow");
			return;
		}

		entry.Count += indices.length;

		var bi: Int = _verticesCount;
		var vb: Int = _verticesCount*_structureLength;
		var vi: Int = 0;
		
		while (vi < vertices.length) 
		{
			_vbCache.set(vb, vertices[vi]*transform.ScaleX + transform.X); vi++; vb++;
			_vbCache.set(vb, vertices[vi]*transform.ScaleY + transform.Y); vi++; vb++;
			_vbCache.set(vb, vertices[vi]); vi++; vb++;
			_vbCache.set(vb, vertices[vi]); vi++; vb++;
		}

		for (i in indices) 
		{
			_ibCache.set(_indicesCount, bi + i);
			_indicesCount++;
		}

		_verticesCount += Std.int(vertices.length / _structureLength);
	}

	public function end(): Void
	{
	}

	public function apply(framebuffer: Framebuffer): Void 
	{
		var lockCount = _verticesCount*_structureLength;
		var vbData = _vb.lock(0, lockCount);
		for (i in 0...lockCount)
		{
			vbData.set(i, _vbCache.get(i));
		}
		_vb.unlock();

		var ibData = _ib.lock(0, _indicesCount);
		for (i in 0..._indicesCount)
		{
			ibData.set(i, _ibCache.get(i));
		}
		_ib.unlock();

		_transfom = FastMatrix4.orthogonalProjection(0, framebuffer.width, 0, framebuffer.height, -1, 1);
		var g = framebuffer.g4;
		g.begin();
		g.clear(Color.fromFloats(0.0, 0.0, 0.3), 1.0);
		g.setVertexBuffer(_vb);
		g.setIndexBuffer(_ib);
		g.setPipeline(_pipeline);
		g.setMatrix(_transfomID, _transfom);
		for (entry in _entries) 
		{
			g.setTexture(_textureID, entry.Texture); 
			g.drawIndexedVertices(entry.Start, entry.Count);
    	}
		g.end();
	}
}