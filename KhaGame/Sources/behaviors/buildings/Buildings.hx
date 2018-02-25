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
	public function new(tiles: TileMap, states: TileStruct, renderData: TileInfos, buildings: Vector<BuildingResource>, buildingsInstances: Array<BuildingInstance>)
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
		if (!_tileStates.validateTiles(tiles, 0)) 
			return null;
		_state.BuildingType = type;
		_state.StagesCount = Std.random(4);
		_state.Health = _state.StagesCount + Std.random(3);
		_state.Size = size;
		var instance = new BuildingInstance(x, y, _state);
		var id = _buildingsInstances.length;
		_buildingsInstances[id] = instance;
		_tileStates.setTiles(tiles, id+1);
		Statistics.Instance.reportBuildingsCount(_buildingsInstances.length);
		return instance;
	}

	public function removeBuilding(instance: BuildingInstance): Void
	{
		_state.decode(instance.State);
		var building = _buildings[_state.BuildingType];
		var tiles = building.getTiles(instance.getX(), instance.getY(), _state.Size);
		_tileStates.setTiles(tiles, 0);
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
		//_frustum = e.Frustum;
		_tiles.query(e.Frustum, _renderData);
	}

	public function proirity(): Int
	{
		return 0;
	}
	
	public function motionStart(x: Int, y: Int): MotionHandleMode
	{
		if (_frustum == null) return MotionHandleMode.None;
		var t = Transform.fromXY(0, 0);
		var removeList= new List<BuildingInstance>();
		for (i in 0..._renderData.Count)
		{
			var d = _renderData.Data[i];
			var state = _tileStates.get(d.X, d.Y);
			if (state == 0) continue;
			var buildingInstnce = _buildingsInstances[state-1];
			_state.decode(buildingInstnce.State);
			t.X = d.RenderX - _frustum.X;
			t.Y = d.RenderY - _frustum.Y;
			var type = _state.BuildingType;
			if (_buildings[type].hitTest(x, y, t))
			{
				removeList.add(buildingInstnce);
			}
		}
		for (i in removeList)
		{
			removeBuilding(i);
		}
		return MotionHandleMode.None;
	}
	
	public function motionMove(x: Int, y: Int): MotionHandleMode
	{
		return MotionHandleMode.None;
	}
	public function motionEnd(x: Int, y: Int): Void
	{
		// apply action
	}

	var _frustum: Aabb;
	var _state: BuildingState;
	var _tiles: TileMap;
	var _renderData: TileInfos;
	var _tileStates: TileStruct;
	var _gen: BuildingGen;
	var _buildings: Vector<BuildingResource>;
	var _buildingsInstances: Array<BuildingInstance>;
}