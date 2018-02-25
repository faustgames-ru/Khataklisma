package engine;

import kha.math.FastVector2;

class Aabb
{
	public var X: Float;
	public var Y: Float;
	public var Sx: Float;
	public var Sy: Float;


	public function include(x: Float, y: Float): Bool
	{
		var dx = x - X;
		var dy = y - Y;
		return -Sx < dx && -Sy < dy && dx < Sx && dy < Sy;
	}

	public function minX(): Float
	{
		return X - Sx;
	}

	public function maxX(): Float
	{
		return X + Sx;
	}
	
	public function minY(): Float
	{
		return Y - Sy;
	}

	public function maxY(): Float
	{
		return Y + Sy;
	}

	public static function fromVertices2(vertices: Array<FastVector2>): Aabb
	{
		var minX: Float = MathHelpers.MaxFloat;
		var minY: Float = MathHelpers.MaxFloat;
		var maxX: Float = MathHelpers.MinFloat;
		var maxY: Float = MathHelpers.MinFloat;
		for (v in vertices)
		{
			if (v.x < minX)
				minX = v.x;
			if (v.y < minY)
				minY = v.y;
			if (v.x > maxX)
				maxX = v.x;
			if (v.y > maxY)
				maxY = v.y;
		}
		return new Aabb((minX+maxX)*0.5, (minY+maxY)*0.5, (maxX-minX)*0.5, (maxY-minY)*0.5);
	}

	public static function fromXY(x: Float, y: Float): Aabb
	{
		return new Aabb(x, y, 1, 1);
	}

	public static function fromXYSize(x: Float, y: Float, sx: Float, sy: Float): Aabb
	{
		return new Aabb(x, y, sx, sy);
	}

	public function clone(): Aabb
	{
		return new Aabb(X, Y, Sx, Sy);
	}

	function new(x: Float, y: Float, sx: Float, sy: Float)
	{
		X = x;
		Y = y;
		Sx = sx;
		Sy = sy;
	}
}