package behaviors.buildings;

import entities.IComponent;
import entities.UpdateContext;
import entities.LoadContext;
import entities.EntitySystem;
import engine.tilemap.TileInfos;
import engine.tilemap.TileStruct;
import engine.Transform;
import haxe.ds.Vector;

class BuildingsRender implements IComponent 
{	
	public var Layer: Int = 0;

	public function new(layer: Int, states: TileStruct<BuildingInstance>, renderData: TileInfos, buildings: Vector<BuildingResource>, buildingsInstances: Array<BuildingInstance>)
	{
		Layer = layer;
		_renderData = renderData;
		_tileStates = states;
		_buildings = buildings;
		_buildingsInstances = buildingsInstances;
		_buildingState = new BuildingState();
	}

	public function getSystemId(): Int
	{
		return EntitySystem.SytemRenderId;
	}

	public function load(e: LoadContext): Void
	{

	}
	
	public function update(e: UpdateContext): Void
	{
		var t = Transform.fromXY(0, 0);		
		for (i in 0..._renderData.Count)
		{
			var d = _renderData.Data[i];
			var buildingInstnce =  _tileStates.get(d.X, d.Y);
			if (buildingInstnce == null) continue;
			_buildingState.decode(buildingInstnce.State);
			t.X = d.RenderX;
			t.Y = d.RenderY;
			var type = _buildingState.BuildingType;
			_buildings[type].draw(Layer, e.Render, t, _buildingState);
		}
	}

	var _renderData: TileInfos;
	var _tileStates: TileStruct<BuildingInstance>;
	var _buildingsInstances: Array<BuildingInstance>;
	var _buildings: Vector<BuildingResource>;
	var _buildingState: BuildingState;
}