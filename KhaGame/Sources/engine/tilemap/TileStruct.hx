package engine.tilemap;

import engine.MathHelpers;
import haxe.ds.Vector;
import kha.math.Vector2i;

class TileStruct<T>
{
	public var SizeX: Int;
	public var SizeY: Int;
	public var Map: Vector<T>;
	
	public function validateTiles(tiles: Array<Vector2i>, value: T): Bool
	{
		for (v in tiles)
		{
			if (v.x < 0) return false;
			if (v.y < 0) return false;
			if (v.x >= SizeX) return false;
			if (v.y >= SizeX) return false;
			if (get(v.x, v.y) != value) return false;
		}
		return true;
	}

	public function setTiles(tiles: Array<Vector2i>, value: T): Void
	{
		for (v in tiles)
		{
			set(v.x, v.y, value);
		}
	}
	public function getAddress(x: Int, y: Int): Int
	{
		var rx: Int = MathHelpers.range(x, SizeX);
		var ry: Int = MathHelpers.range(y, SizeY);
		return ry*SizeX + rx;
	}

	public function get(x: Int, y: Int): T
	{
		return Map[getAddress(x, y)];
	}

	public function set(x: Int, y: Int, value: T): Void
	{
		Map[getAddress(x, y)] = value;
	}

	public function new(sizeX: Int, sizeY: Int, value: T)
	{
		SizeX = sizeX;
		SizeY = sizeY;
		Map = new Vector<T>(sizeX*sizeY);
		for (i in 0...Map.length)		
		{
			Map[i] = value;
		}
	}
}