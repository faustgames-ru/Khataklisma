package entities;

import engine.resources.ResourcesManager;
import engine.input.MotionsManager;

class LoadContext
{
	public var Owner: Entity;
	public var Resources: ResourcesManager;
	public var Motions: MotionsManager;
	
	public function new(resources: ResourcesManager, motions: MotionsManager)
	{
		Motions = motions;
		Resources = resources;
	}
}