package engine.resources;

import kha.Blob;
import kha.Image;

import engine.render.IRenderService;
import engine.resources.ResourceImage;
import haxe.ds.Vector;
import Xml;
import Std;
import Map;

class ResourceFont
{
	public var Pages: Vector<ResourceImage>;
	public var Glyphs: Map<Int, ResourceFontGlyph>;
	public var Kernings: Map<Int, Int>;

	public var LineHeight: Int;
	public var LineBase: Int;

	public static function fromBlob(xmlData: Blob, page: Image): ResourceFont
	{
		var result = new ResourceFont();
		var xml = Xml.parse(xmlData.toString());
		var fontRoot = xml.elementsNamed("font").next();
		var commonRoot = fontRoot.elementsNamed("common").next();
		
		result.LineHeight = Std.parseInt(commonRoot.get("lineHeight"));
		result.LineBase = Std.parseInt(commonRoot.get("base"));	
		var pageTexture = ResourceImage.fromImage(page);
		result.Pages = Vector.fromArrayCopy([pageTexture]);
		result.Glyphs = new Map<Int, ResourceFontGlyph>();
		result.Kernings = new Map<Int, Int>();
		var charsRoot = fontRoot.elementsNamed("chars").next();
		var chars = charsRoot.elementsNamed("char");

		for(char in chars)
		{
			var glyph = new ResourceFontGlyph();
			glyph.Id = Std.parseInt(char.get("id"));
			glyph.X = Std.parseInt(char.get("x"));
			glyph.Y = Std.parseInt(char.get("y"));
			glyph.W = Std.parseInt(char.get("width"));
			glyph.H = Std.parseInt(char.get("height"));
			glyph.XOffset = Std.parseInt(char.get("xoffset"));
			glyph.YOffset = Std.parseInt(char.get("yoffset"));
			glyph.XAdvance = Std.parseInt(char.get("xadvance"));
			glyph.Texture = pageTexture.createSubImage(glyph.X, glyph.Y, glyph.W, glyph.H);
			glyph.RenderXOffset = glyph.XOffset + glyph.W*0.5;
			glyph.RenderYOffset = result.LineBase- glyph.YOffset - glyph.H*0.5;
			result.Glyphs.set(glyph.Id, glyph);
		}
		
		var kerningsRoot = fontRoot.elementsNamed("kernings").next();
		var kernings = kerningsRoot.elementsNamed("kerning");
		for(kerning in kernings)
		{
			var first = Std.parseInt(kerning.get("first"));
			var second = Std.parseInt(kerning.get("second"));
			var amount = Std.parseInt(kerning.get("amount"));
			var key = first << 16 + second;
			result.Kernings.set(key, amount);
		}
		
		return result;
	}

	public function draw(render: IRenderService, transform: Transform, text: String): Void
	{
		var i: Int = 0;
		var x: Float = 0;
		var t = transform.clone();
		while (i < text.length)
		{
			var ch = text.charCodeAt(i);
			var glyph = Glyphs.get(ch);
			t.X = transform.X + x + glyph.RenderXOffset*t.ScaleX;
			t.Y = transform.Y + glyph.RenderYOffset*t.ScaleY;
			glyph.Texture.draw(render, t);
			x += glyph.XAdvance*t.ScaleX;
			i++;
		};
	}

	private function new()
	{
	}

}

class ResourceFontGlyph
{
	public var Id: Int;
	public var X: Int;
	public var Y: Int;
	public var W: Int;
	public var H: Int;
	public var XOffset: Int;
	public var YOffset: Int;
	public var XAdvance: Int;
	public var Texture: ResourceImage;
	public var RenderXOffset: Float;
	public var RenderYOffset: Float;

	public function new()
	{

	}
}
