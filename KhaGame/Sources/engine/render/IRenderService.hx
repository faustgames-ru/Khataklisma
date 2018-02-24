package engine.render;

import kha.Image;
import kha.Framebuffer;
import haxe.ds.Vector;

interface IRenderService
{
	function begin(): Void;
	function drawImage(texture: Image, vertices: Vector<Float>, indices: Vector<Int>, transform: Transform): Void;	
	function end(): Void;	
	function apply(framebuffer: Framebuffer): Void;
}