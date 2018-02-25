package entities;

import engine.render.IRenderService;
import engine.input.MotionsManager;
import engine.Aabb;
import engine.Viewport;

class UpdateContext
{
	public function new (render: IRenderService, motions: MotionsManager, ellapsetTime: Float)
	{
		Motions = motions;
		Render = render;
		EllapsetTime = ellapsetTime;
		Frustum = Aabb.fromXY(0, 0);
		Viewport = new Viewport();
	}

	public var Viewport: Viewport;
	public var Frustum: Aabb;
	public var Render: IRenderService;
	public var EllapsetTime: Float;
	public var Motions: MotionsManager;
}