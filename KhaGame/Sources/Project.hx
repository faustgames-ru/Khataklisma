package;

import haxe.ds.Vector;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Assets;
import kha.math.FastMatrix2;
import kha.math.Vector2i;
import utils.Statistics;
import engine.render.IRenderService;
import engine.render.RenderService;
import engine.resources.ResourceFont;
import engine.resources.ResourceAtlas;
import engine.resources.ResourceImage;
import engine.resources.ResourceTileMap;
import engine.resources.ResourcesManager;
import engine.Aabb;
import engine.input.MotionsManager;
import engine.tilemap.TileMap;
import engine.tilemap.TilesPalette;
import entities.EntityWorld;
import entities.UpdateContext;
import entities.LoadContext;

class Project 
{	
	public function new() 
	{
		_frequency = 1 / 60;
		_render = new RenderService();		
		_resources = new ResourcesManager();
		_motions = new MotionsManager();
		_inputBroker = new InputBroker(_motions);		
		_updateContext = new UpdateContext(_render, _motions, _frequency);
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, _frequency);				
		Assets.loadEverything(afterLoadAssets);
	}

	function afterLoadAssets(): Void 
	{
		_resources.DefaultFont = ResourceFont.fromBlob(Assets.blobs.calibri_fnt, Assets.images.calibri_0);
		_resources.DefaultAtlas = ResourceAtlas.fromBlob(Assets.blobs.all_scene_images_json, Assets.images.all_scene_images);
		_resources.DefaultTiles = ResourceTileMap.fromBlob(Assets.blobs.tiles_json);
		_world = new EntityWorld(new LoadContext(_resources, _motions));
		_world.addEntity(EntityFactory.camera());
		var palette = new TilesPalette("landscapeTiles_", ".png",  _resources.DefaultAtlas);
		_world.addEntity(EntityFactory.tilemap(_resources.DefaultTiles, palette));		
		_world.addEntity(EntityFactory.fpsCounter(-502, -370));// todo: independent coordinate system?
	}

	function update(): Void 
	{		
		updateInternal();
	}

	function updateInternal(): Void 
	{		
		if (_world == null) return;
		_motions.update();
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
	private var _inputBroker: InputBroker;
	private var _motions: MotionsManager;
}
 