package entities;

import engine.resources.ResourcesManager;

class LoadContext
{
	public var Owner: Entity;
	public var Resources: ResourcesManager;
	
	public function new(resources: ResourcesManager)
	{
		Resources = resources;
	}
}