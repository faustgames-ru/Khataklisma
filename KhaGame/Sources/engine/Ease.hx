package engine;

class Ease
{
	public static function lerp(from: Float, to: Float, u: Float): Float
	{
		return from + (to - from) * u;
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