package engine.resources;

import engine.tilemap.TileStruct;
import kha.Blob;
import haxe.ds.Vector;

class ResourceTileMap
{
	public var Data: TileStruct<Int>;

	public static function fromBlob(jsonData: Blob): ResourceTileMap
	{
		return new ResourceTileMap(jsonData);
	}

	private function new(jsonData: Blob)
	{
		var jsonTiles: JsonTilesRoot = haxe.Json.parse(jsonData.toString());
		var layer = jsonTiles.layers[0];
		Data = new TileStruct<Int>(layer.width, layer.height, 0);
		for (i in 0...Data.Map.length)		
		{
			Data.Map[i] = layer.data[i] - 1;
		}
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