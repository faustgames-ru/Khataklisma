package behaviors.buildings;

import entities.IComponent;
import entities.UpdateContext;
import entities.LoadContext;
import entities.EntitySystem;
import engine.tilemap.TileInfos;
import engine.tilemap.TileMap;
import engine.tilemap.TileStruct;
import engine.Transform;
import utils.Statistics;
import haxe.ds.Vector;
import engine.input.IMotionHandler;
import engine.input.MotionHandleMode;
import engine.Aabb;

class Buildings implements IComponent implements IMotionHandler
{	
	public function new(tiles: TileMap, states: TileStruct<BuildingInstance>, renderData: TileInfos, buildings: Vector<BuildingResource>, buildingsInstances: Array<BuildingInstance>)
	{
		_tiles = tiles;
		_renderData = renderData;
		_tileStates = states; 
		_buildings = buildings;
		_state = new BuildingState();
		_buildingsInstances = buildingsInstances;
		spawnBuildings(1000);
	}

	public function spawnBuilding(x: Int, y: Int, size: Int, type: Int): BuildingInstance
	{
		var building = _buildings[type];
		var tiles = building.getTiles(x, y, size);
		if (!_tileStates.validateTiles(tiles, null)) 
			return null;
		_state.BuildingType = type;
		_state.StagesCount = Std.random(4);
		_state.Health = _state.StagesCount + Std.random(3);
		_state.Size = size;
		var instance = new BuildingInstance(x, y, _state);
		_buildingsInstances[_buildingsInstances.length] = instance;
		_tileStates.setTiles(tiles, instance);
		Statistics.Instance.reportBuildingsCount(_buildingsInstances.length);
		return instance;
	}

	public function removeBuilding(instance: BuildingInstance): Void
	{
		_state.decode(instance.State);
		var building = _buildings[_state.BuildingType];
		var tiles = building.getTiles(instance.getX(), instance.getY(), _state.Size);
		_tileStates.setTiles(tiles, null);
		_buildingsInstances.remove(instance);
		Statistics.Instance.reportBuildingsCount(_buildingsInstances.length);
	}

	public function removeBuildings(count: Int): Void
	{
		for (i in 0...count)	
		{
			if (_buildingsInstances.length == 0) 
				return;
			var instance = _buildingsInstances[_buildingsInstances.length - 1];
			removeBuilding(instance);
		}
	}

	public function spawnBuildings(count: Int): Void
	{
		for (i in 0...count)
		{
			for (j in 0...50)
			{
				var rndX = Std.random(_tileStates.SizeX);
				var rndY = Std.random(_tileStates.SizeY);
				var type = Std.random(_buildings.length);
				var size = Std.random(3) + 1;
				var result = spawnBuilding(rndX, rndY, size, type);
				if (result != null)
					break;
			}			
		}
			
	}

	public function getSystemId(): Int
	{
		return EntitySystem.SytemBehaviorId;
	}

	public function load(e: LoadContext): Void
	{
		e.Motions.addHandler(this);
	}
	
	public function update(e: UpdateContext): Void
	{
		_frustum = e.Frustum;
		_tiles.query(e.Frustum, _renderData);
	}

	public function proirity(): Int
	{
		return 50;
	}
	
	public function motionStart(x: Int, y: Int): MotionHandleMode
	{		
		return MotionHandleMode.None;
	}
	
	public function motionMove(x: Int, y: Int): MotionHandleMode
	{
		return MotionHandleMode.None;
	}
	public function motionEnd(x: Int, y: Int): Void
	{
		if (_frustum == null) return;
		var t = Transform.fromXY(0, 0);
		var hitList= new List<BuildingInstance>();
		for (i in 0..._renderData.Count)
		{
			var d = _renderData.Data[i];
			var instance = _tileStates.get(d.X, d.Y);
			if (instance == null) continue;
			_state.decode(instance.State);
			t.X = d.RenderX - _frustum.X;
			t.Y = d.RenderY - _frustum.Y;
			var type = _state.BuildingType;
			if (_buildings[type].hitTest(x, y, t, _state))
			{
				hitList.add(instance);
			}

		}
		var last = hitList.last();
		if (last != null)
		{
			_state.decode(last.State);
			if (!_state.removeStage())
			{
				removeBuilding(last);
			}
			else
			{
				last.State = _state.encode();
			}

		}
	}

	var _frustum: Aabb;
	var _state: BuildingState;
	var _tiles: TileMap;
	var _renderData: TileInfos;
	var _tileStates: TileStruct<BuildingInstance>;
	var _gen: BuildingGen;
	var _buildings: Vector<BuildingResource>;
	var _buildingsInstances: Array<BuildingInstance>;
}