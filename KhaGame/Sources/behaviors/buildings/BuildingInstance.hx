package behaviors.buildings;

class BuildingInstance
{
	public var State: Int;
	public var TileAddress: Int;

	public function getX(): Int
	{
		return TileAddress & 0x0000ffff;
	}

	public function getY(): Int
	{
		return (TileAddress & 0xffff0000)>>16;
	}

	public function new(x: Int, y: Int, state: BuildingState)
	{
		State = state.encode();
		TileAddress = x + (y << 16);
	}
}