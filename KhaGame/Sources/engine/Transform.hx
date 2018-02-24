package engine;

class Transform
{
	public var X: Float;
	public var Y: Float;
	public var ScaleX: Float;
	public var ScaleY: Float;

	public static function fromXY(x: Float, y: Float): Transform
	{
		return new Transform(x, y, 1, 1);
	}

	public static function fromXYScale(x: Float, y: Float, scaleX: Float, scaleY: Float): Transform
	{
		return new Transform(x, y, scaleX, scaleY);
	}

	public function clone(): Transform
	{
		return new Transform(X, Y, ScaleX, ScaleY);
	}

	function new(x: Float, y: Float, scaleX: Float, scaleY: Float)
	{
		X = x;
		Y = y;
		ScaleX = scaleX;
		ScaleY = scaleY;
	}
}