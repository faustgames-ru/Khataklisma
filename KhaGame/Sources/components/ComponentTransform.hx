package components;

import engine.Transform;
import entities.IComponent;
import entities.EntitySystem;
import entities.LoadContext;
import entities.UpdateContext;

class ComponentTransform implements IComponent
{
	public var Value: Transform;
	
	public function new (value: Transform)
	{
		Value = value;
	}

	public function getSystemId(): Int
	{
		return EntitySystem.SytemTransformId;
	}

	public function load(e: LoadContext): Void
	{

	}
	
	public function update(e: UpdateContext): Void
	{

	}
}