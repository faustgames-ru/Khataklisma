package engine.input;

class MotionInfo
{
	public var Motion: MotionType;
	public var Id: Int;
	public var X: Int;
	public var Y: Int;
	public function new(motionType: MotionType, id: Int, x: Int, y: Int)
	{
		Motion = motionType;
		Id = id;
		X = x;
		Y = y;
	}
}
