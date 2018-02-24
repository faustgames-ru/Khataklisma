package;

import engine.Transform;
import engine.resources.ResourceImage;
import entities.Entity;
import components.ComponentTransform;
import components.ComponentText;
import components.ComponentSprite;
import behaviors.FpsCounter;

class EntityFactory
{
	public static function Sprite(x: Float, y: Float, image: ResourceImage): Entity
	{
		return new Entity(
			[
				new ComponentTransform(Transform.fromXY(x, y)), 
				new ComponentSprite(image), 
			]);
	}

	public static function FpsCounter(x: Float, y: Float): Entity
	{
		return new Entity(
			[
				new ComponentTransform(Transform.fromXY(x, y)), 
				new ComponentText(), 
				new FpsCounter()
			]);
	}
}