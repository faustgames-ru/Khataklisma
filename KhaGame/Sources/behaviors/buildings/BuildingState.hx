package behaviors.buildings;

class BuildingState
{
	public var StagesCount: Int;
	public var Health: Int;
	public var Size: Int;
	public var BuildingType: Int;

	public function new()
	{
	}

	public function encode(): Int
	{
		return StagesCount + (Health << 4) + (Size << 8) + (BuildingType << 16);
	}
	
	public function decode(value: Int)
	{
		StagesCount = value & 0x0000000f;
		Health = (value & 0x000000f0) >> 4;
		Size =(value & 0x00000f00) >> 8;
		BuildingType = (value & 0xffff0000) >> 16;
	}

}
