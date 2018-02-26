package;

import engine.Transform;
import engine.resources.ResourceImage;
import engine.render.RenderLayer;
import engine.tilemap.TilesPalette;
import engine.tilemap.TileInfos;
import engine.tilemap.TileMap;
import engine.tilemap.TileStruct;
import engine.Aabb;
import entities.Entity;
import components.ComponentTransform;
import components.ComponentText;
import components.ComponentSprite;
import components.ComponentGuiRect;
import components.ComponentTilesRender;
import behaviors.FpsCounter;
import behaviors.Camera;
import behaviors.buildings.Buildings;
import behaviors.buildings.BuildingsRender;
import behaviors.buildings.BuildingResource;
import behaviors.buildings.BuildingInstance;
import behaviors.AddButton;
import kha.math.FastMatrix2;
import haxe.ds.Vector;

class EntityFactory
{
	public static function tilemap(tiles: TileStruct<Int>, palette: TilesPalette, buildings: Vector<BuildingResource>): Entity
	{
		var transform = new FastMatrix2(64, -64, -32, -32);
		var tilesMap = new TileMap(tiles, transform, palette);
		var tilesRender = new TileInfos(16*1024);
		var buildingsStates = new TileStruct<BuildingInstance>(tiles.SizeX, tiles.SizeY, null);
		var buildingsInstances = new Array<BuildingInstance>();
		return new Entity(
			[
				new Buildings(tilesMap, buildingsStates, tilesRender, buildings, buildingsInstances), 
				new ComponentTilesRender(RenderLayer.GameLayer0, tilesMap, tilesRender), 
				new BuildingsRender(RenderLayer.GameLayer1, buildingsStates, tilesRender, buildings, buildingsInstances), 
			]);
	}

	public static function sprite(layer: Int, x: Float, y: Float, image: ResourceImage): Entity
	{
		return new Entity(
			[
				new ComponentTransform(Transform.fromXY(x, y)), 
				new ComponentSprite(layer, image), 
			]);
	}

	public static function guiPanel(aabb: Aabb, image: ResourceImage): Entity
	{
		return new Entity(
			[
				new ComponentGuiRect(RenderLayer.GuiLayer, aabb, image), 
			]);
	}

	public static function camera(): Entity
	{
		return new Entity(
			[
				new Camera(), 
			]);
	}

	public static function addButton(x: Float, y: Float, image: ResourceImage, title: String, buildings: Buildings, count: Int): Entity
	{
		return new Entity(
			[
				new ComponentTransform(Transform.fromXYScale(x, y, 0.7, 0.7)), 
				new ComponentSprite(RenderLayer.GuiLayer, image), 
				new ComponentText(RenderLayer.GuiLayer, title), 
				new AddButton(buildings, count)
			]);
	}

	public static function fpsCounter(x: Float, y: Float): Entity
	{
		return new Entity(
			[
				new ComponentTransform(Transform.fromXYScale(x, y, 1.0, 1.0)), 
				new ComponentText(RenderLayer.GuiLayer, "fps:"), 
				new FpsCounter()
			]);
	}
}