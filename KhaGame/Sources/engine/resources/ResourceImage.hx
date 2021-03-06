package engine.resources;

import kha.Image;
import kha.math.FastVector2;
import engine.render.IRenderService;
import engine.Aabb;
import haxe.ds.Vector;

class ResourceImage
{
	public static var QuadIndices: Vector<Int> = Vector.fromArrayCopy([0, 1, 2, 0, 2, 3]);
	public var Vertices: Vector<Float>;
	public var Indices: Vector<Int>;
	public var Texture: Image;
	public var Bounds: Aabb;
	
	public function hitTest(x: Int, y: Int, t: Transform): Bool
	{		
		var tx = (x-t.X);
		var ty = (y-t.Y);
		return Bounds.includeScaled(tx, ty, t.ScaleX, t.ScaleY);
	}

	public function createSubImage(x: Int, y: Int, w: Int, h: Int): ResourceImage
	{
		var result = new ResourceImage();
		result.Texture = Texture;
		var sx: Float = w / 2;
		var sy: Float = h / 2;
		var tx0: Float = x / (Texture.width);
		var ty0: Float = y / (Texture.height);
		var tx1: Float = (x+w) / (Texture.width);
		var ty1: Float = (y+h) / (Texture.height);
		result.Bounds = Aabb.fromXYSize(0, 0, sx, sy);
		result.Vertices = Vector.fromArrayCopy(
		[
			-sx, -sy, tx0, ty1,
			-sx, sy, tx0, ty0,
			sx, sy, tx1, ty0,
			sx, -sy, tx1, ty1,
		]);
		result.Indices = QuadIndices;
		return result;
	}

	public function createMeshImage(x: Float, y: Float, xy: Vector<Vector<Int>>, uv: Vector<Vector<Int>>, inds: Vector<Vector<Int>>): ResourceImage
	{
		var result = new ResourceImage();
		result.Texture = Texture;
		result.Vertices = new Vector<Float>(xy.length*4);
		var testVertices = new Array<FastVector2>();
		var xx:Float = 0;
		var yy:Float = 0;
		for (i in 0...xy.length)
		{
			xx = xy[i][0] - x;
			yy =  y - xy[i][1];
			testVertices[i] = new FastVector2(xx, yy);
			result.Vertices[i*4 + 0] = xx;
			result.Vertices[i*4 + 1] =yy;
			result.Vertices[i*4 + 2] = uv[i][0]/(Texture.width - 1);
			result.Vertices[i*4 + 3] = uv[i][1]/(Texture.height - 1);
		}
		result.Bounds = Aabb.fromVertices2(testVertices);

		result.Indices = new Vector<Int>(inds.length*3);
		for (i in 0...inds.length)
		{
			result.Indices[i*3 + 0] = inds[i][0];
			result.Indices[i*3 + 1] = inds[i][1];
			result.Indices[i*3 + 2] = inds[i][2];
		}

		return result;
	}

	public static function fromImage(texture: Image): ResourceImage
	{
		var result = new ResourceImage();
		result.Texture = texture;
		var sx: Float = texture.width / 2;
		var sy: Float = texture.height / 2;
		result.Bounds = Aabb.fromXYSize(0, 0, sx, sy);

		result.Vertices = Vector.fromArrayCopy(
		[
			-sx, -sy, 0, 1,
			-sx, sy, 0, 0,
			sx, sy, 1, 0,
			sx, -sy, 1, 1,
		]);
		result.Indices = QuadIndices;
		return result;
	}

	public function draw(layer: Int, render: IRenderService, transform: Transform): Void
	{
		render.drawImage(layer, Texture, Vertices, Indices, transform);
	}

	public function drawQuad(layer: Int, render: IRenderService, vertices: Vector<Float>): Void
	{
		render.drawImage(layer, Texture, vertices, QuadIndices, Transform.empty);
	}

	private function new()
	{

	}
}