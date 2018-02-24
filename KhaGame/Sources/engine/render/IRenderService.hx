package engine.render;

import kha.Image;
import kha.Framebuffer;
import haxe.ds.Vector;
import kha.math.FastMatrix4;

interface IRenderService
{
	function setTransform(layer: Int, trasform: FastMatrix4): Void;
	function begin(): Void;
	function drawImage(layer: Int, texture: Image, vertices: Vector<Float>, indices: Vector<Int>, transform: Transform): Void;	
	function end(): Void;	
	function apply(framebuffer: Framebuffer): Void;
}