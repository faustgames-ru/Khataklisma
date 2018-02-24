package components;

import engine.resources.ResourceImage;
import entities.EntitySystem;
import entities.IComponent;
import entities.LoadContext;
import entities.UpdateContext;

class ComponentSprite implements IComponent
{
	public var Transform: ComponentTransform;
	public var Image: ResourceImage;
	public var Layer: Int = 0;

	public function getSystemId(): Int
	{
		return EntitySystem.SytemRenderId;
	};

	public function new (layer: Int, image: ResourceImage)
	{
		Layer = layer;
		Image = image;
	}

	public function load(e: LoadContext): Void
	{		
		Transform = e.Owner.get(ComponentTransform);
	}

	public function update(e: UpdateContext): Void
	{
		Image.draw(Layer, e.Render, Transform.Value);
	}
}