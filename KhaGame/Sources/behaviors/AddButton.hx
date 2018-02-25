package behaviors;

import entities.IComponent;
import entities.UpdateContext;
import entities.LoadContext;
import entities.EntitySystem;
import engine.input.IMotionHandler;
import engine.input.MotionHandleMode;
import behaviors.buildings.Buildings;
import components.ComponentTransform;
import components.ComponentSprite;

class AddButton implements IComponent implements IMotionHandler
{	
	public var Transform: ComponentTransform;
	public var Sprite: ComponentSprite;
	public var Buildings: Buildings;
	public var Count: Int;

	public function new (buildings: Buildings, count: Int)
	{		
		Buildings = buildings;
		Count = count;
	}

	public function getSystemId(): Int
	{
		return EntitySystem.SytemBehaviorId;
	};

	public function load(e: LoadContext): Void
	{
		e.Motions.addHandler(this);
		Transform = e.Owner.get(ComponentTransform);
		Sprite = e.Owner.get(ComponentSprite);
	}

	public function update(e: UpdateContext): Void
	{
		// do hit test
	}
	
	public function proirity(): Int
	{
		return 0;
	}
	
	public function motionStart(x: Int, y: Int): MotionHandleMode
	{
		// do hit test
		if (Sprite.Image.hitTest(x, y, Transform.Value))
		{
			if (Count > 0)
			{
				Buildings.spawnBuildings(Count);
			}
			else if (Count < 0)
			{
				Buildings.removeBuildings(-Count);
			}
			return MotionHandleMode.Handled;
		}
		return MotionHandleMode.None;

	}
	
	public function motionMove(x: Int, y: Int): MotionHandleMode
	{
		return MotionHandleMode.Joint;
	}
	public function motionEnd(x: Int, y: Int): Void
	{
		// apply action
	}

}