package components;

import entities.EntitySystem;
import entities.IComponent;
import entities.LoadContext;
import entities.UpdateContext;
import engine.input.IMotionHandler;
import engine.input.MotionHandleMode;

class ComponentMotion implements IComponent implements IMotionHandler
{
	public var Proxy: IMotionHandler;

	public function getSystemId(): Int
	{
		return EntitySystem.SytemMotionId;
	};

	public function new ()
	{
	}

	public function load(e: LoadContext): Void
	{		
	}

	public function proirity(): Int
	{
		if (Proxy == null)
			return 0;
		return Proxy.proirity();
	}

	public function motionStart(x: Int, y: Int): MotionHandleMode
	{
		if (Proxy == null)
			return MotionHandleMode.None;	
		return Proxy.motionStart(x, y);
	}

	public function motionMove(x: Int, y: Int): MotionHandleMode
	{
		if (Proxy == null)
			return MotionHandleMode.None;	
		return Proxy.motionMove(x, y);
	}

	public function motionEnd(x: Int, y: Int): Void
	{
		if (Proxy == null)
			return;	
		Proxy.motionEnd(x, y);
	}

	public function update(e: UpdateContext): Void
	{
		e.World.Motions.addHandler(this);
	}
}