package entities;

import Std;

class Entity
{
	public var Components = new List<IComponent>();

	public function new(components: Array<IComponent>)
	{
		add(components);
	}

	public function load(e: LoadContext): Void
	{
		e.Owner = this;
		for (i in Components)
		{
			i.load(e);
		}
	}

	public function get(type: Any): Any
	{
		for (i in Components)
		{			
			if (Std.is(i, type))
			{
				return i;
			}			
		}
		return null;
	}

	private function add(components: Array<IComponent>): Void
	{
		for (i in components)
		{
			Components.add(i);
		}
	}
}