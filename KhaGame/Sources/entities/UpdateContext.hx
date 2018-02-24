package entities;

import engine.render.IRenderService;
import engine.input.MotionsManager;

class UpdateContext
{
	public function new (render: IRenderService, motions: MotionsManager, ellapsetTime: Float)
	{
		Motions = motions;
		Render = render;
		EllapsetTime = ellapsetTime;
	}

	public var Render: IRenderService;
	public var EllapsetTime: Float;
	public var Motions: MotionsManager;
}