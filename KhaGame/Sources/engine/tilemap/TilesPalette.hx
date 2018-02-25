package engine.tilemap;

import engine.resources.ResourceImage;
import engine.resources.ResourceAtlas;
import haxe.ds.Vector;

class TilesPalette
{
	public var Data: Vector<ResourceImage>;
	public function new (name: String, ext: String, atlas: ResourceAtlas)
	{		
		var data = new Array<ResourceImage>();
		for (file in atlas.Frames.keys())
		{
			if (!StringTools.startsWith(file, name)) continue;
			if (!StringTools.endsWith(file, ext)) continue;
			var numberString = file.substr(name.length, file.length - name.length - ext.length);
			var number = Std.parseInt(numberString);
			if (number == null) continue;
			data[number] = atlas.Frames.get(file);
		}
		Data = Vector.fromArrayCopy(data);
	}
}