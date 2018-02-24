package;

import engine.Transform;
import engine.resources.ResourceImage;
import engine.render.RenderLayer;
import entities.Entity;
import components.ComponentTransform;
import components.ComponentText;
import components.ComponentSprite;
import behaviors.FpsCounter;
import behaviors.Camera;

class EntityFactory
{
	public static function Sprite(layer: Int, x: Float, y: Float, image: ResourceImage): Entity
	{
		return new Entity(
			[
				new ComponentTransform(Transform.fromXY(x, y)), 
				new ComponentSprite(layer, image), 
			]);
	}

	public static function Camera(): Entity
	{
		return new Entity(
			[
				new Camera(), 
			]);
	}

	public static function FpsCounter(x: Float, y: Float): Entity
	{
		return new Entity(
			[
				new ComponentTransform(Transform.fromXY(x, y)), 
				new ComponentText(RenderLayer.GuiLayer), 
				new FpsCounter()
			]);
	}
}