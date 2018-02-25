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
import engine.render.RenderLayer;
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
import behaviors.buildings.BuildingGen;
import behaviors.buildings.BuildingGenConfig;
import behaviors.buildings.Buildings;

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
		var redButtonSprite = ResourceImage.fromImage(Assets.images.red_button);
		var greenButtonSprite = ResourceImage.fromImage(Assets.images.green_button1);


		var palette = new TilesPalette("landscapeTiles_", ".png",  _resources.DefaultAtlas);
		var gen = createBuildingsGen();
		var buildings = gen.genAll();
		_world = new EntityWorld(new LoadContext(_resources, _motions));
		_world.addEntity(EntityFactory.camera());
		var tileMap = EntityFactory.tilemap(_resources.DefaultTiles.Data, palette, buildings);
		var buildings: Buildings = tileMap.get(Buildings);
		_world.addEntity(tileMap);

		_world.addEntity(EntityFactory.addButton(-450, -300, redButtonSprite, "-1000", buildings, -1000));
		_world.addEntity(EntityFactory.addButton(-450, -200, redButtonSprite, "-100", buildings, -100));
		_world.addEntity(EntityFactory.addButton(-450, -100, redButtonSprite, "-1", buildings, -1));
		
		_world.addEntity(EntityFactory.addButton(450, -300, greenButtonSprite, "+1000", buildings, 1000));
		_world.addEntity(EntityFactory.addButton(450, -200, greenButtonSprite, "+100", buildings, 100));
		_world.addEntity(EntityFactory.addButton(450, -100, greenButtonSprite, "+1", buildings,  1));
		_world.addEntity(EntityFactory.fpsCounter(0, 350));// todo: independent coordinate system?
	}


	function createBuildingsGen(): BuildingGen
	{
		var config: Array<BuildingGenConfig> = haxe.Json.parse(Assets.blobs.buildings_json.toString());
		var gen = new BuildingGen(_resources.DefaultAtlas, config);
		return gen;
	}

	function update(): Void 
	{		
		updateInternal();
	}

	function updateInternal(): Void 
	{		
		if (_world == null) return;
		_motions.update(_updateContext);
		_world.update(_updateContext);
	}

	function render(framebuffer: Framebuffer): Void 
	{		
		Statistics.Instance.reportRenderFrame(Scheduler.realTime());		
		_updateContext.Viewport.Width = framebuffer.width;
		_updateContext.Viewport.Height = framebuffer.height;
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
 