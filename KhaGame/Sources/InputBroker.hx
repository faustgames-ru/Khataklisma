package;

import kha.input.Surface;
import kha.input.Mouse;
import engine.input.MotionType;
import engine.input.MotionsManager;

class InputBroker
{
	public function new(motions: MotionsManager) 
	{
		_motions = motions;
		Surface.get().notify(touchStart, touchEnd, touchMove);
		Mouse.get().notify(mouseDown, mouseUp, mouseMove, mouseWheel, mouseLeave);
	}

	function touchStart(id: Int, x: Int, y: Int)
	{
		_motions.reportMotion(MotionType.Start, id, x, y);
	}

	function touchEnd(id: Int, x: Int, y: Int)
	{
		_motions.reportMotion(MotionType.End, id, x, y);
	}

	function touchMove(id: Int, x: Int, y: Int)
	{
		_motions.reportMotion(MotionType.Move, id, x, y);
	}

	function mouseDown(bt: Int, x: Int, y: Int)
	{		
		if (bt != 0) return;
		_mouseButton0State = true;
		_mouseX = x;
		_mouseY = y;
		touchStart(-1, x, y);
	}

	function mouseUp(bt: Int, x: Int, y: Int)
	{
		if (bt != 0) return;
		_mouseButton0State = false;
		_mouseX = x;
		_mouseY = y;
		touchEnd(-1, x, y);
	}

	function mouseMove(x: Int, y: Int, dx: Int, dy: Int)
	{
		if (!_mouseButton0State) return;
		_mouseX = x;
		_mouseY = y;
		touchMove(-1, x, y);
	}

	function mouseWheel(value: Int)
	{
	}

	function mouseLeave()
	{
		if (!_mouseButton0State) return;
		touchEnd(-1, _mouseX, _mouseY);
	}

	var _motions: MotionsManager;
	var _mouseButton0State: Bool;
	var _mouseX: Int;
	var _mouseY: Int;

}