package engine.resources;

import haxe.ds.Vector;
import engine.MathHelpers;
import kha.Blob;
import haxe.ds.Vector;

class ResourceTileMap
{
	public var SizeX: Int;
	public var SizeY: Int;
	public var Map: Vector<Int>;

	public static function fromValue(sizeX: Int, sizeY: Int, value: Int): ResourceTileMap
	{
		var result = new ResourceTileMap();
		result.SizeX = sizeX;
		result.SizeY = sizeY;
		result.Map = new Vector<Int>(sizeX*sizeY);
		for (i in 0...result.Map.length)		
		{
			result.Map[i] = value;
		}
		return result;
	}

	public static function fromBlob(jsonData: Blob): ResourceTileMap
	{
		var jsonTiles: JsonTilesRoot = haxe.Json.parse(jsonData.toString());
		var layer = jsonTiles.layers[0];
		var result = new ResourceTileMap();
		result.SizeX = layer.width;
		result.SizeY = layer.height;
		result.Map = new Vector<Int>(layer.data.length);
		for (i in 0...result.Map.length)		
		{
			result.Map[i] = layer.data[i] - 1;
		}
		return result;
	}

	public function get(x: Int, y: Int): Int
	{
		var rx: Int = MathHelpers.range(x, SizeX);
		var ry: Int = MathHelpers.range(y, SizeY);
		return Map[ry*SizeX + rx];
	}

	public function set(x: Int, y: Int, value: Int): Void
	{
		var rx = MathHelpers.range(x, SizeX);
		var ry = MathHelpers.range(y, SizeY);
		Map[ry*SizeX + rx] = value;
	}

	private function new()
	{

	}
}

class JsonTilesLayer
{
	public var data: Vector<Int>;
	public var width: Int;
	public var height: Int;
}
class JsonTilesRoot
{
	public var layers: Vector<JsonTilesLayer>;
}