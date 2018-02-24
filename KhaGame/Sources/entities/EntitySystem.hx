package entities;

import List;

class EntitySystem
{
	public static var SytemNoneId: Int = -1;
	public static var SytemBehaviorId: Int = 0;
	public static var SytemTransformId: Int = 1;
	public static var SytemRenderId: Int = 2;
	
	public function new()
	{
	}

	public function clear(): Void
	{
		_components.clear();
	}

	public function add(component: IComponent): Void
	{
		_components.add(component);
	}

	public function update(e: UpdateContext): Void
	{
		for (i in _components)
		{
			i.update(e);
		}
	}

	private var _components: List<IComponent> = new List<IComponent>();
}