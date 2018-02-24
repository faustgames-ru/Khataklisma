package utils;

class Statistics 
{
	public static var Instance: Statistics = new Statistics();
	public var LastFps: Float = 0;
	public var LastRenderDelay: Float = 0;
	public var LastFpsPerSecond: Float = 0;

	public function reportRenderFrame(realTime: Float): Void
	{
		if(_lastTime >= 0) 
		{
			LastRenderDelay = (realTime - _lastTime);
			LastFps = 1.0 / LastRenderDelay;
		}
		_lastTime = realTime;
		_perSecondTime += LastRenderDelay;
		_framesCount++;
		if (_perSecondTime > 1.0)
		{
			LastFpsPerSecond =_framesCount /  _perSecondTime;
			_framesCount = 0;
			_perSecondTime = 0;
		}
	}

	private function new()
	{

	}

	private var _lastTime: Float = -1;
	private var _perSecondTime: Float = -1;
	private var _framesCount: Float = 0;
}