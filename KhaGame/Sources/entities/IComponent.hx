package entities;

interface IComponent
{
	function getSystemId(): Int;

	function load(e: LoadContext): Void;
	function update(e: UpdateContext): Void;
}