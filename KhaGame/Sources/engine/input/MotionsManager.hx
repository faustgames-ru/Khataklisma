package engine.input;

import entities.UpdateContext;

class MotionsManager
{
	public function new()
	{

	}

	public function addHandler(handler: IMotionHandler)
	{
		var index = _handlers.length;
		_handlers[index] = handler;
	} 

	public function reportMotion(type: MotionType, id: Int, x: Int, y: Int)
	{
		_motions.add(new MotionInfo(type, id, x, y));
	} 

	public function update(e: UpdateContext)
	{
		var sx: Int = Std.int(e.Viewport.Width/2);
		var sy: Int = Std.int(e.Viewport.Height/2);
		
		for (m in _motions)
		{
			var x: Int = m.X-sx;
			var y: Int = sy - m.Y;
			var handler = _handled.get(m.Id);
			if (handler != null)
			{
				invokeHandlers(x, y, m, handler);
			}
			else
			{
				sortHandlers();
				for (h in _handlers)
				{
					invokeHandlers(x, y, m, h);
					handler = _handled.get(m.Id);
					if (handler != null)
					{
						break;
					}
				}
			}
		}
		_motions.clear();		
	}

	private function invokeHandlers(x: Int, y: Int, m: MotionInfo, h: IMotionHandler)
	{
		if (m.Motion == MotionType.Start)
		{
			if (h.motionStart(x, y) == MotionHandleMode.Handled)
			{
				_handled.set(m.Id, h);
			}
		}
		if (m.Motion == MotionType.Move)
		{
			if (h.motionMove(x, y) == MotionHandleMode.Handled)
			{
				_handled.set(m.Id, h);
			}
		}
		if (m.Motion == MotionType.End)
		{
			_handled.set(m.Id, null);
			h.motionEnd(x, y);
		}
	}
	private function sortHandlers()
	{
		_handlers.sort(function (a, b): Int
		{
			if (a.proirity() < b.proirity())
				return -1;
			if (a.proirity() > b.proirity())
				return 1;
			return 0;
		});
	}
	
	private function addHandlers(handlers: List<IMotionHandler>, handler: IMotionHandler): Void
	{
		for (h in handlers)
		{
			if(h == handler) return;
		}
		handlers.add(handler);
	}
	
	private function replaceHandlers(handlers: List<IMotionHandler>, handler: IMotionHandler): Void
	{
		handlers.clear();		
		handlers.add(handler);
	}

	var	_handled: Map<Int, IMotionHandler> = new Map<Int, IMotionHandler>();
	var _motions: List<MotionInfo> = new List<MotionInfo>();
	var _handlers: Array<IMotionHandler> = new Array<IMotionHandler>();
}