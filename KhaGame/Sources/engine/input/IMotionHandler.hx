package engine.input;

interface IMotionHandler
{
	function proirity(): Int;
	function motionStart(x: Int, y: Int): MotionHandleMode;
	function motionMove(x: Int, y: Int): MotionHandleMode;
	function motionEnd(x: Int, y: Int): Void;
}