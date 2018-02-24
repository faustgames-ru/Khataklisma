package engine.input;

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

	public function update()
	{
		for (m in _motions)
		{
			for (h in _handlers)
			{
				switch(m.Motion)
				{
					case MotionType.None:
						break;
					case MotionType.Start:
					 	h.motionStart(m.X, m.Y);
						break;
					case MotionType.Move:
					 	h.motionMove(m.X, m.Y);
						break;
					case MotionType.End:
					 	h.motionEnd(m.X, m.Y);
						break;
				}
			}
		}
		_motions.clear();		
	}

	function _update()
	{
		for (m in _motions)
		{
			_replaceList.clear();
			var handlers = getHandlers(m.Id);
			if (m.Motion == MotionType.Start)
			{
				sortHandlers();
				for (h in _handlers)
				{
					var mode = h.motionStart(m.X, m.Y);
					if (mode == MotionHandleMode.None)
						continue;
					if (processHandler(mode, h)) 
						break;
				}
			}
			else if (m.Motion == MotionType.Move)
			{
				if (handlers.isEmpty())
				{
					sortHandlers();
					for (h in _handlers)
					{
						var mode = h.motionMove(m.X, m.Y);
						if (processHandler(mode, h)) 
							break;
					}
				}
				else
				{
					for (h in handlers)
					{
						var mode = h.motionMove(m.X, m.Y);
						if (processHandler(mode, h)) 
							break;
					}
				}
			}
			else if (m.Motion == MotionType.End)
			{
				for (h in handlers)
				{
					h.motionEnd(m.X, m.Y);
				}
			}
			handlers.clear();
			for(h in _replaceList)
			{
				handlers.add(h);
			}
		}
		_motions.clear();
	}


	private function processHandler(mode: MotionHandleMode, h: IMotionHandler): Bool
	{
		switch(mode)
		{
			case MotionHandleMode.None:
				return false;
			case MotionHandleMode.Handled:
				_replaceList.clear();
				_replaceList.add(h);
				return true;
			case MotionHandleMode.Joint:
				_replaceList.add(h);
				return false;
		}
		return false;
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

	private function getHandlers(id: Int): List<IMotionHandler>
	{
		var result = _handlersById.get(id);
		if(result == null)
		{
			result = new List<IMotionHandler>();
			_handlersById.set(id, result);
		}
		return result;
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

	var _motions: List<MotionInfo> = new List<MotionInfo>();
	var _handlersById: Map<Int, List<IMotionHandler>> = new Map<Int, List<IMotionHandler>>();
	var _handlers: Array<IMotionHandler> = new Array<IMotionHandler>();
	var _replaceList: List<IMotionHandler> = new List<IMotionHandler>();
}