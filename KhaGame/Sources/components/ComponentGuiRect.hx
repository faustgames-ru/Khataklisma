package components;

import engine.resources.ResourceImage;
import entities.EntitySystem;
import entities.IComponent;
import entities.LoadContext;
import entities.UpdateContext;
import engine.Aabb;
import haxe.ds.Vector;

class ComponentGuiRect implements IComponent
{
	public var Aabb: Aabb;
	public var Vertices: Vector<Float>;
	public var Image: ResourceImage;
	public var Layer: Int = 0;

	public function getSystemId(): Int
	{
		return EntitySystem.SytemRenderId;
	};

	public function new (layer: Int, aabb: Aabb, image: ResourceImage)
	{
		Layer = layer;
		Image = image;
		Aabb = aabb;
		
		Vertices = Vector.fromArrayCopy(
		[
			aabb.minX(), aabb.minY(), 0, 1,
			aabb.minX(), aabb.maxY(), 0, 0,
			aabb.maxX(), aabb.maxY(), 1, 0,
			aabb.maxX(), aabb.minY(), 1, 1,
		]);
	}

	public function load(e: LoadContext): Void
	{		
	}

	public function update(e: UpdateContext): Void
	{
		Image.drawQuad(Layer, e.Render, Vertices);
	}
}