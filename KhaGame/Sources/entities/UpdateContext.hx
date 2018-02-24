package entities;

import engine.render.IRenderService;

class UpdateContext
{
	public function new (render: IRenderService, ellapsetTime: Float)
	{
		Render = render;
		EllapsetTime = ellapsetTime;
	}
	public var Render: IRenderService;
	public var EllapsetTime: Float;
}