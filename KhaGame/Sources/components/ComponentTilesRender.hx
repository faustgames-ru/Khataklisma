package components;

import engine.resources.ResourceImage;
import engine.resources.ResourceAtlas;
import engine.resources.ResourceTileMap;
import engine.tilemap.TileMap;
import engine.tilemap.TileInfos;
import engine.tilemap.TilesPalette;
import engine.Aabb;
import entities.EntitySystem;
import entities.IComponent;
import entities.LoadContext;
import entities.UpdateContext;
import kha.math.FastMatrix2;
import kha.math.Vector2i;
import haxe.ds.Vector;

class ComponentTilesRender implements IComponent
{
	public var Layer: Int = 0;
	public var TileMap: TileMap;
	public var RenderData: TileInfos;

	public function getSystemId(): Int
	{
		return EntitySystem.SytemRenderId;
	};

	public function new (layer: Int, tiles: TileMap, renderData: TileInfos)
	{
		Layer = layer;
		TileMap = tiles;
		RenderData = renderData;
	}

	public function load(e: LoadContext): Void
	{		
	}

	public function update(e: UpdateContext): Void
	{
		TileMap.renderTiles(Layer, e.Render, RenderData);
	}
}