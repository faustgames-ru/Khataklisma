package behaviors;

import entities.IComponent;
import entities.UpdateContext;
import entities.LoadContext;
import entities.EntitySystem;
import engine.input.IMotionHandler;
import engine.input.MotionHandleMode;
import engine.MathHelpers;
import engine.Aabb;
import kha.math.FastMatrix4;
import haxe.ds.Vector;

class Camera implements IComponent implements IMotionHandler
{	
	public function new ()
	{		
		_cameraX = _cameraTargetX = 0;
		_cameraY = _cameraTargetY = 3000;
		_moveHistory = new Vector<MoveHistory>(5);
		for (i in 0..._moveHistory.length)
		{
			if (_moveHistory[i] == null)
			{
				_moveHistory[i] = new MoveHistory();
			}
			_moveHistory[i].X = _cameraX;
			_moveHistory[i].Y = _cameraY;
		}
	}

	public function getSystemId(): Int
	{
		return EntitySystem.SytemBehaviorId;
	};

	public function load(e: LoadContext): Void
	{
		e.Motions.addHandler(this);
	}

	public function update(e: UpdateContext): Void
	{
		_cameraX = MathHelpers.lerp(_cameraX, _cameraTargetX, MathHelpers.saturate(e.EllapsetTime*4));
		_cameraY = MathHelpers.lerp(_cameraY, _cameraTargetY, MathHelpers.saturate(e.EllapsetTime*4));
		updateHistory(_cameraX, _cameraY);
		var w= e.Viewport.Width*0.5;
		var h= e.Viewport.Height*0.5;
		e.Frustum = Aabb.fromXYSize(-_cameraX, -_cameraY, w+128, h+128); // todo: remove magic nubmers
		var transform =FastMatrix4.translation(_cameraX, _cameraY, 0);
		e.Render.setTransform(0, transform);
		e.Render.setTransform(1, transform);
	}
	
	public function proirity(): Int
	{
		return 1000;
	}
	
	public function motionStart(x: Int, y: Int): MotionHandleMode
	{
		_touchX = x;
		_touchY = y;
		_touchCameraX = _cameraTargetX =_cameraX;
		_touchCameraY = _cameraTargetY =_cameraY;		
		clearHistory(_cameraX, _cameraY);
		return MotionHandleMode.Joint;
	}
	
	public function motionMove(x: Int, y: Int): MotionHandleMode
	{
		_cameraTargetX = _cameraX = _touchCameraX + x - _touchX;
		_cameraTargetY = _cameraY = _touchCameraY + y - _touchY;		
		if (Math.abs(x - _touchX) > 5 || Math.abs(y - _touchY) > 5)
			return MotionHandleMode.Handled;
		return MotionHandleMode.Joint;
	}
	public function motionEnd(x: Int, y: Int): Void
	{
		var dx: Float = 0;
		var dy: Float = 0;
		for (i in 1..._moveHistory.length)
		{
			dx += _moveHistory[i].X - _moveHistory[i-1].X;
			dy += _moveHistory[i].Y - _moveHistory[i-1].Y;
		}		
		_cameraTargetX = _cameraX + dx;
		_cameraTargetY = _cameraY + dy;		
	}

	private function clearHistory(x: Float, y: Float): Void
	{
		for (i in 0..._moveHistory.length)
		{
			_moveHistory[i].X = x;
			_moveHistory[i].Y = y;
		}
	}
	private function updateHistory(x: Float, y: Float): Void
	{
		for (i in 1..._moveHistory.length)
		{
			_moveHistory[i - 1].X = _moveHistory[i].X;
			_moveHistory[i - 1].Y = _moveHistory[i].Y;
		}		
		var h = _moveHistory.length - 1;
		_moveHistory[h].X = x;
		_moveHistory[h].Y = y;
	}

	var _cameraX: Float;
	var _cameraY: Float;
	var _cameraTargetX: Float;
	var _cameraTargetY: Float;

	var _touchX: Float;
	var _touchY: Float;
	var _touchCameraX: Float;
	var _touchCameraY: Float;

	var _moveHistory: Vector<MoveHistory>;
}

class MoveHistory
{
	public var X: Float;
	public var Y: Float;
	public function new()
	{

	}
}