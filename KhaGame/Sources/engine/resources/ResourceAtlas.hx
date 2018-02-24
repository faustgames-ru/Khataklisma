package engine.resources;

import kha.Blob;
import kha.Image;
import haxe.ds.Vector;

class ResourceAtlas
{
	public var Pages: Vector<ResourceImage>;
	public var Frames: Map<String, ResourceImage>;

	public static function fromBlob(jsonData: Blob, page: Image): ResourceAtlas
	{
		var result = new ResourceAtlas();
		var pageTexture = ResourceImage.fromImage(page);
		result.Pages = Vector.fromArrayCopy([pageTexture]);
		
		var atlasData = haxe.Json.parse(jsonData.toString());
		var frames: Array<JsonAtlasFrame> = atlasData.frames;
		result.Frames = new Map<String, ResourceImage>();
		for (i in 0...frames.length)
		{
			var x = frames[i].sourceSize.w * frames[i].pivot.x;
			var y = frames[i].sourceSize.h * frames[i].pivot.y;			
			var subImage = pageTexture.createMeshImage(
					x, y, 
					frames[i].vertices, 
					frames[i].verticesUV, 
					frames[i].triangles);
			
			//var subImage = pageTexture.createSubImage(frames[i].frame.x, frames[i].frame.y, frames[i].frame.w, frames[i].frame.h);
			result.Frames.set(frames[i].filename, subImage);
		}
		return result;
	}

	private function new()
	{

	}
}

class JsonAtlasFrameRect
{
	public var x: Int;
	public var y: Int;
	public var w: Int;
	public var h: Int;
}

class JsonAtlasFrameSize
{
	public var w: Int;
	public var h: Int;
}

class JsonAtlasFramePivot
{
	public var x: Float;
	public var y: Float;
}

class JsonAtlasFrame
{
	public var filename: String;
	public var frame: JsonAtlasFrameRect;
	public var rotated: Bool;
	public var trimmed: Bool;
	public var spriteSourceSize: JsonAtlasFrameRect;
	public var sourceSize: JsonAtlasFrameSize;
	public var pivot: JsonAtlasFramePivot;
	public var vertices: Vector<Vector<Int>>;
	public var verticesUV: Vector<Vector<Int>>;
	public var triangles: Vector<Vector<Int>>;
}