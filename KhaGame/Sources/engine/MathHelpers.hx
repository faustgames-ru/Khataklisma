package engine;

import kha.math.FastMatrix2;

class MathHelpers
{
	public static var MaxFloat: Float = 1e20;
	public static var MinFloat: Float = -1e20;

	public static function inverseMatrix2(m: FastMatrix2): FastMatrix2
	{
		var d = m._00 * m._11 - m._01 * m._10;
		return new FastMatrix2(m._11/d, -m._10/d, -m._01/d, m._00/d);
	}
	
	public static function lerp(from: Float, to: Float, u: Float): Float
	{
		return from + (to - from) * u;
	}

	public static function clamp(from: Float, to: Float, u: Float): Float
	{
		if (u < from) 
			return from;
		if (u > to) 
			return to;
		return u;
	}

	public static function range(u: Int, count: Int): Int
	{
		if (u < 0) 
			return 0;
		if (u >= count) 
			return count;
		return u;
	}

	public static function saturate(u: Float): Float
	{
		if (u < 0) 
			return 0;
		if (u > 1) 
			return 1;
		return u;
	}
}