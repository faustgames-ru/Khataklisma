package entities;

class EntitySystemRender extends EntitySystem
{
	public override function update(e: UpdateContext)
	{
		e.Render.begin();
		super.update(e);
		e.Render.end();

	}
}