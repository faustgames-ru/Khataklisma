package behaviors.buildings;

import engine.resources.ResourceAtlas;
import haxe.ds.Vector;
import kha.Blob;
import Std;

class BuildingGen
{
	public function new(atlas: ResourceAtlas, config: Array<BuildingGenConfig>)
	{
		_atlas = atlas;
		_config = config;
	}

	public function create(xDir: Int, yDir: Int, basis: String, stage: String, roof: String): BuildingResource
	{
		var bImg = _atlas.Frames.get(basis);
		var sImg = _atlas.Frames.get(stage);
		var rImg = _atlas.Frames.get(roof);
		return new BuildingResource(bImg, sImg, rImg, 64, 36, xDir, yDir);

	}
	
	public function genAll(): Vector<BuildingResource>
	{
		var resultList = new List<BuildingResource>();

		for(c in _config)
		{			
			genAllFromConfig(c, resultList);
		}
		var result = new Vector<BuildingResource>(resultList.length);
		var i: Int = 0;
		for(b in resultList)
		{		
			result[i] = b;
			i++;
		}
		return result;
	}

	public function genAllFromConfig(config: BuildingGenConfig, result: List<BuildingResource>): Void
	{
		for (b in config.base)
		{
			for (s in config.stage)
			{
				for (r in config.roof)
				{
					result.add(create(config.xDir, config.yDir, b, s, r));
				}
			}
		}
	}

	var _config: Array<BuildingGenConfig>;
	var _fileName: String;
	var _ext: String;
	var _atlas: ResourceAtlas;
}