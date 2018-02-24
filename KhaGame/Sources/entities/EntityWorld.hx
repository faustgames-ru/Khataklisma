package entities;

class EntityWorld
{	
	public function new(loadContext: LoadContext)
	{
		_loadContext = loadContext;
		_systems = 
		[
			new EntitySystem(), // behaviors
			new EntitySystem(), // transforms
			new EntitySystemRender() // render
		];
	}

	public function addEntity(entity: Entity)
	{
		_entities.add(entity);
		entity.load(_loadContext);
	}

	public function update(e: UpdateContext)
	{
		for (i in _systems)
		{
			i.clear();
		}
		// todo: filt visible entities for update in systems
		for (i in _entities)
		{
			if (!i.Enabled) continue;
			for (c in i.Components)
			{
				var systemId = c.getSystemId();
				if (systemId < 0) continue;
				_systems[systemId].add(c);
			}
		}
		for (i in _systems)
		{
			i.update(e);
		}
	}

	private var _entities: List<Entity> = new List<Entity>();
	private var _systems: Array<EntitySystem>;
	private var _loadContext: LoadContext;
}