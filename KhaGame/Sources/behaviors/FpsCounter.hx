package behaviors;

import entities.IComponent;
import entities.UpdateContext;
import entities.LoadContext;
import entities.EntitySystem;
import components.ComponentText;
import utils.Statistics;

class FpsCounter implements IComponent
{	
	public function new ()
	{
		
	}

	public function getSystemId(): Int
	{
		return EntitySystem.SytemBehaviorId;
	};

	public function load(e: LoadContext): Void
	{
		_text = e.Owner.get(ComponentText);
	}

	public function update(e: UpdateContext): Void
	{
		var fps =Std.int(Statistics.Instance.LastFpsPerSecond);
		_text.Text = 'fps: $fps';
	}

	private var _text: ComponentText;
}