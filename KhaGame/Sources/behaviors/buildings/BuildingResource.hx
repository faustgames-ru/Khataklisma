package behaviors.buildings;

import engine.resources.ResourceImage;
import engine.render.IRenderService;
import engine.Transform;
import kha.math.Vector2i;

class BuildingResource
{
	public var Base: ResourceImage;
	public var Stage: ResourceImage;
	public var Roof: ResourceImage;
	public var XDir: Int;
	public var YDir: Int;
	public var BaseH: Float;
	public var StageH: Float;	

	public var Direction: BuildingDirection;

	public function new(basis: ResourceImage, stage: ResourceImage, roof: ResourceImage, baseH: Float, stageH: Float, xDir: Int, yDir: Int)
	{
		Base = basis;
		Stage = stage;
		Roof = roof;
		BaseH = baseH;
		StageH = stageH;
		XDir = xDir;
		YDir = yDir;
	}

	public function getTiles(x: Int, y: Int, size: Int): Array<Vector2i>
	{
		if(size == 1)
		{
			return [new Vector2i(x, y)];
		}
		if(size == 2)
		{
			return [new Vector2i(x, y), new Vector2i(x+XDir, y+YDir)];
		}
		return 
		[
			new Vector2i(x-1, y-1), new Vector2i(x, y-1), new Vector2i(x+1, y-1),
			new Vector2i(x-1, y), new Vector2i(x, y), new Vector2i(x+1, y),
			new Vector2i(x-1, y+1), new Vector2i(x, y+1), new Vector2i(x+1, y+1),
		];
	}

	public function hitTest(x: Int, y: Int, t: Transform): Bool
	{		
		if (Base.hitTest(x, y, t))
			return true;
		t.Y += BaseH;
		var count = 2;
		for (i in 0...count)
		{
			if (Stage.hitTest(x, y, t))
				return true;
			t.Y += StageH;
		}
		if (Roof.hitTest(x, y, t))
			return true;
		return false;
	}

	public function draw(layer: Int, render: IRenderService, t: Transform, state: BuildingState): Void
	{
		Base.draw(layer, render, t);
		t.Y += BaseH;
		var count = 2;
		for (i in 0...count)
		{
			Stage.draw(layer, render, t);
			t.Y += StageH;
		}
		Roof.draw(layer, render, t);
	}
}

