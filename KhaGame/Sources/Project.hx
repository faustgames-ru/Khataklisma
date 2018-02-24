package;

import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Assets;
import utils.Statistics;
import engine.render.IRenderService;
import engine.render.RenderService;
import engine.resources.ResourceFont;
import engine.resources.ResourceAtlas;
import engine.resources.ResourcesManager;
import entities.EntityWorld;
import entities.UpdateContext;
import entities.LoadContext;

class Project {	
	public function new() 
	{
		_frequency = 1 / 60;
		_render = new RenderService();		
		_resources = new ResourcesManager();
		_updateContext = new UpdateContext(_render, _frequency);
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, _frequency);		
		Assets.loadEverything(afterLoadAssets);
	}

	function afterLoadAssets(): Void 
	{
		_resources.DefaultFont = ResourceFont.fromBlob(Assets.blobs.calibri_fnt, Assets.images.calibri_0);
		_resources.ResourceAtlas = ResourceAtlas.fromBlob(Assets.blobs.all_scene_images_json, Assets.images.all_scene_images);
		_world = new EntityWorld(new LoadContext(_resources));
		
		var exx:Float = 50;
		var exy:Float = -25;
		
		var eyx:Float = -50;
		var eyy:Float = -25;

		var cx:Float = 512;
		var cy:Float = 384;

		for (l in 0...2)
		{
			for (x in -20...21)
			{
				for (y in -20...21)
				{
					var sx = cx + exx*x + eyx*y;
					var sy = cy + exy*x + eyy*y;
					_world.addEntity(EntityFactory.Sprite(sx, sy, 
						_resources.ResourceAtlas.Frames.get("buildingTiles_000.png")));
				}
			}
		}
		_world.addEntity(EntityFactory.FpsCounter(10, 10));
	}

	function update(): Void 
	{		
		if (_world == null) return;
		_world.update(_updateContext);
	}

	function render(framebuffer: Framebuffer): Void 
	{		
		Statistics.Instance.reportRenderFrame(Scheduler.realTime());
		_render.apply(framebuffer);
	}

	private var _render:  IRenderService;
	private var _resources: ResourcesManager;
	private var _world: EntityWorld;
	private var _frequency: Float;
	private var _updateContext: UpdateContext;
}
 