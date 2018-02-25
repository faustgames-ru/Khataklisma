package engine.tilemap;

import haxe.ds.Vector;

class TileInfos
{
	public var Data: Vector<TileInfo>;
	public var Count: Int;
	public function new(caheSize: Int)
	{
		Data = new Vector<TileInfo>(caheSize);
		Count = 0;
		for (i in 0...Data.length)
		{
			Data[i] = new TileInfo();
		}
	}

	public function clear()
	{
		Count = 0;
	}

	public function add(x: Int, y: Int, rx: Float, ry: Float, value: Int): Bool
	{
		if (Count >= Data.length)
			return false;
		var info = Data[Count];
		info.X = x;
		info.Y = y;
		info.RenderX = rx;
		info.RenderY = ry;
		info.Value = value;
		Count++;
		return true;
	}

}