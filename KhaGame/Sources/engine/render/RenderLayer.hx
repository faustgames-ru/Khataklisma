package engine.render;

import List;
import kha.math.FastMatrix4;

class RenderLayer
{
	public static var GameLayer0: Int = 0;
	public static var GameLayer1: Int = 1;
	public static var GuiLayer: Int = 2;

	public var Entries: List<RenderEntry>;
	public var Transform: FastMatrix4;

	public function new()
	{
		Entries = new List<RenderEntry>();
		Transform = FastMatrix4.identity();
	}

	public function clear(): Void
	{
		Entries.clear();
	}
}