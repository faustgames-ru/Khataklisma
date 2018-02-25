package components;

import entities.IComponent;
import entities.EntitySystem;
import entities.UpdateContext;
import entities.LoadContext;
import engine.resources.ResourceFont;

class ComponentText implements IComponent
{
	public var Text: String;
	public var Layer: Int;
	public var Font: ResourceFont;
	public var Transform: ComponentTransform;

	public function getSystemId(): Int
	{
		return EntitySystem.SytemRenderId;
	};

	public function new (layer: Int, text: String)
	{
		Layer = layer;
		Text = text;
	}

	public function load(e: LoadContext): Void
	{		
		Font = e.Resources.DefaultFont;
		Transform = e.Owner.get(ComponentTransform);
	}

	public function update(e: UpdateContext): Void
	{
		Font.draw(Layer, e.Render, Transform.Value, Text);
	}
}