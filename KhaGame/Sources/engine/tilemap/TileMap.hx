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
	public var Tiles: TileStruct<Int>;
	public var Axis: FastMatrix2;
	public var Palette: TilesPalette;
	public var OwnFrustum: Aabb;
	public function new(tiles: TileStruct<Int>, transform: FastMatrix2, palette: TilesPalette)
	{
		Tiles = tiles;
		Axis = transform;
		Palette = palette;
		OwnFrustum = Aabb.fromXY(0, 0);
	}

	public function query(frustum: Aabb, resultTiles: TileInfos): Void
	{
		resultTiles.clear();
		OwnFrustum.X = frustum.X;
		OwnFrustum.Y = frustum.Y - 128; // crutch
		OwnFrustum.Sx = frustum.Sx;
		OwnFrustum.Sy = frustum.Sy;

		var inverse: FastMatrix2 = MathHelpers.inverseMatrix2(Axis);

		var invf = Aabb.fromVertices2([
			inverse.multvec(new FastVector2(OwnFrustum.X-OwnFrustum.Sx, OwnFrustum.Y-OwnFrustum.Sy)),
			inverse.multvec(new FastVector2(OwnFrustum.X-OwnFrustum.Sx, OwnFrustum.Y+OwnFrustum.Sy)),
			inverse.multvec(new FastVector2(OwnFrustum.X+OwnFrustum.Sx, OwnFrustum.Y+OwnFrustum.Sy)),
			inverse.multvec(new FastVector2(OwnFrustum.X+OwnFrustum.Sx, OwnFrustum.Y-OwnFrustum.Sy)),
		]);		
		var minY = MathHelpers.range(Std.int(invf.minY()-1), Tiles.SizeY);
		var minX = MathHelpers.range(Std.int(invf.minX()-1), Tiles.SizeX);
		var maxY = MathHelpers.range(Std.int(invf.maxY()+1), Tiles.SizeY); // crutch
		var maxX = MathHelpers.range(Std.int(invf.maxX()+1), Tiles.SizeX);
		var p = new FastVector2(0, 0);
		var walker = new TilesWalker(OwnFrustum, resultTiles, Axis, Tiles);
		
		var posY = minY;
		while (posY < maxY)
		{
			var x = minX;
			var y = posY;
			while (y >= minY && x <= maxX)
			{
				if (!walker.Walk(x, y)) 
					return;
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
					return;
				x++;
				y--;
			}
			posX++;
		}	
	}

	public function renderTiles(layer:Int, render: IRenderService, resultTiles: TileInfos): Void
	{
		var t = Transform.fromXY(0, 0);
		for (i in 0...resultTiles.Count)
		{
			var tile = resultTiles.Data[i];
			t.X = tile.RenderX;
			t.Y = tile.RenderY;
			var image = Palette.Data[tile.Value];
			if (image == null) continue;
			image.draw(layer, render, t);
		}
	}
}

class TilesWalker
{
	public var ResultTiles: TileInfos;
	public var Frustum: Aabb;
	public var Index: Int = 0;
	public var Axis: FastMatrix2;
	public var Tiles: TileStruct<Int>;
	public var p: FastVector2 = new FastVector2(0, 0);

	public function new(frustum: Aabb, resultTiles: TileInfos, axis: FastMatrix2, tiles: TileStruct<Int>)
	{
		Frustum = frustum;
		ResultTiles = resultTiles;
		Axis = axis;
		Tiles = tiles;
	}

	public function Walk(x: Int, y: Int): Bool
	{
		p.x = x;
		p.y = y;
		var ps = Axis.multvec(p);
		if (!Frustum.include(ps.x, ps.y))
			return true; 
		return ResultTiles.add(x, y, ps.x, ps.y, Tiles.get(x, y));
	}
}
