package components;

import engine.resources.ResourceImage;
import engine.resources.ResourceAtlas;
import engine.resources.ResourceTileMap;
import engine.tilemap.TileMap;
import engine.tilemap.TileInfo;
import engine.tilemap.TilesPalette;
import engine.Aabb;
import entities.EntitySystem;
import entities.IComponent;
import entities.LoadContext;
import entities.UpdateContext;
import kha.math.FastMatrix2;
import kha.math.Vector2i;
import haxe.ds.Vector;

class ComponentTileMap implements IComponent
{
	public var Layer: Int = 0;
	public var TileMap: TileMap;
	public var Palette: TilesPalette;

	public function getSystemId(): Int
	{
		return EntitySystem.SytemRenderId;
	};

	public function new (layer: Int, tiles: ResourceTileMap, palette: TilesPalette)
	{
		Layer = layer;
		var transform = new FastMatrix2(64, -64, -32, -32);
		TileMap = new TileMap(tiles, transform);
		_renderTiles = new Vector<TileInfo>(16*1024);
		for(i in 0..._renderTiles.length)
		{
			_renderTiles[i] = new TileInfo();
		}

		Palette = palette;
	}

	public function load(e: LoadContext): Void
	{		
	}

	public function update(e: UpdateContext): Void
	{
		var count = TileMap.query(e.Frustum, _renderTiles);

		TileMap.renderTiles(e.Frustum, e.Render, _renderTiles, count, Palette);
	}

	private var _renderTiles: Vector<TileInfo>;
}