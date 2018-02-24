package engine.render;

import kha.Image;

class RenderEntry
{
	public var Start: Int;
	public var Count: Int;
	public var Texture: Image;

	public function new(start: Int, image: Image)
	{
		Texture = image;
		Start = start;
		Count = 0;
	}
}