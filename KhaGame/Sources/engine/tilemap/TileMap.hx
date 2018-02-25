package engine.tilemap;

import haxe.ds.Vector;
import engine.MathHelpers;
import engine.Aabb;
import engine.resources.ResourceTileMap;
import engine.resources.ResourceImage;
import engine.render.IRenderService;
import engine.render.RenderLayer;
import kha.math.FastMatrix2;
import kha.math.FastVector2;
import kha.math.Vector2i;

class TileMap
{
	public var Tiles: ResourceTileMap;
	public var Axis: FastMatrix2;

	public function new(tiles: ResourceTileMap, transform: FastMatrix2)
	{
		Tiles = tiles;
		Axis = transform;
	}

	public function query(frustum: Aabb, resultTiles: Vector<TileInfo>): Int
	{
		var inverse: FastMatrix2 = MathHelpers.inverseMatrix2(Axis);

		var invf = Aabb.fromVertices2([
			inverse.multvec(new FastVector2(frustum.X-frustum.Sx, frustum.Y-frustum.Sy)),
			inverse.multvec(new FastVector2(frustum.X-frustum.Sx, frustum.Y+frustum.Sy)),
			inverse.multvec(new FastVector2(frustum.X+frustum.Sx, frustum.Y+frustum.Sy)),
			inverse.multvec(new FastVector2(frustum.X+frustum.Sx, frustum.Y-frustum.Sy)),
		]);		
		var minY = MathHelpers.range(Std.int(invf.minY()-1), Tiles.SizeY);
		var minX = MathHelpers.range(Std.int(invf.minX()-1), Tiles.SizeX);
		var maxY = MathHelpers.range(Std.int(invf.maxY()+1), Tiles.SizeY);
		var maxX = MathHelpers.range(Std.int(invf.maxX()+1), Tiles.SizeX);
		var p = new FastVector2(0, 0);
		var walker = new TilesWalker(frustum, resultTiles, Axis, Tiles);
		
		var posY = minY;
		while (posY < maxY)
		{
			var x = minX;
			var y = posY;
			while (y >= minY && x <= maxX)
			{
				if (!walker.Walk(x, y)) 
				{
					return resultTiles.length;
				}
				x++;
				y--;
			}
			posY++;
		}
		
		var posX = minX;
		while (posX <= maxX)
		{
			var x = posX;
			var y = maxY;
			while (y >= minY && x <= maxX)
			{
				if (!walker.Walk(x, y)) 
				{
					return resultTiles.length;
				}
				x++;
				y--;
			}
			posX++;
		}
	
		return walker.Index;
	}

	public function renderTiles(frustum: Aabb, render: IRenderService, resultTiles: Vector<TileInfo>, count: Int, palette: TilesPalette): Void
	{
		var t = Transform.fromXY(0, 0);
		for (i in 0...count)
		{
			var tile = resultTiles[i];
			t.X = tile.RenderX;
			t.Y = tile.RenderY;
			var image = palette.Data[tile.Value];
			if (image == null) continue;
			image.draw(RenderLayer.GameLayer0, render, t);
		}
	}
}

class TilesWalker
{
	public var ResultTiles: Vector<TileInfo>;
	public var Frustum: Aabb;
	public var Index: Int = 0;
	public var Axis: FastMatrix2;
	public var Tiles: ResourceTileMap;
	public var p: FastVector2 = new FastVector2(0, 0);
	public function new(frustum: Aabb, resultTiles: Vector<TileInfo>, axis: FastMatrix2, tiles: ResourceTileMap)
	{
		Frustum = frustum;
		ResultTiles = resultTiles;
		Axis = axis;
		Tiles = tiles;
	}
	public function Walk(x: Int, y: Int): Bool
	{
		if (Index >= ResultTiles.length) 
			return false;
		p.x = x;
		p.y = y;
		var ps = Axis.multvec(p);
		if (!Frustum.include(ps.x, ps.y))
			return true; 
		var tile =ResultTiles[Index];
		tile.X = x;
		tile.Y = y;
		tile.RenderX = ps.x;
		tile.RenderY = ps.y;
		tile.Value = Tiles.get(x, y);
		Index++;
		return true;
	}
}
