package;

import engine.Transform;
import engine.resources.ResourceImage;
import engine.resources.ResourceAtlas;
import engine.resources.ResourceTileMap;
import engine.render.RenderLayer;
import engine.tilemap.TilesPalette;
import entities.Entity;
import components.ComponentTransform;
import components.ComponentText;
import components.ComponentSprite;
import components.ComponentTileMap;
import behaviors.FpsCounter;
import behaviors.Camera;

class EntityFactory
{
	public static function tilemap(tiles: ResourceTileMap, palette: TilesPalette): Entity
	{
		return new Entity(
			[
				new ComponentTileMap(RenderLayer.GameLayer0, tiles, palette), 
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

	public static function camera(): Entity
	{
		return new Entity(
			[
				new Camera(), 
			]);
	}

	public static function fpsCounter(x: Float, y: Float): Entity
	{
		return new Entity(
			[
				new ComponentTransform(Transform.fromXY(x, y)), 
				new ComponentText(RenderLayer.GuiLayer), 
				new FpsCounter()
			]);
	}
}