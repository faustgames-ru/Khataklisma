package engine.resources;

import engine.tilemap.TileStruct;
import kha.Blob;
import haxe.ds.Vector;

class ResourceTileMap
{
	public var Data: TileStruct;

	public static function fromBlob(jsonData: Blob): ResourceTileMap
	{
		var jsonTiles: JsonTilesRoot = haxe.Json.parse(jsonData.toString());
		var layer = jsonTiles.layers[0];
		var result = new ResourceTileMap();
		result.Data.SizeX = layer.width;
		result.Data.SizeY = layer.height;
		result.Data.Map = new Vector<Int>(layer.data.length);
		for (i in 0...result.Data.Map.length)		
		{
			result.Data.Map[i] = layer.data[i] - 1;
		}
		return result;
	}

	private function new()
	{
		Data = new TileStruct();
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