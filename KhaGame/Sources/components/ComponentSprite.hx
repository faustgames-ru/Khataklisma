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

	public function getSystemId(): Int
	{
		return EntitySystem.SytemRenderID;
	};

	public function new (image: ResourceImage)
	{
		Image = image;
	}

	public function load(e: LoadContext): Void
	{		
		Transform = e.Owner.get(ComponentTransform);
	}

	public function update(e: UpdateContext): Void
	{
		Image.draw(e.Render, Transform.Value);
	}
}