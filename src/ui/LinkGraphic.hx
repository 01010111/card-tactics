package ui;

import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Matrix;

class LinkGraphic extends Sprite {

	public var length:Float = 8;
	public var active:Bool = false;

	var offset_matrix:Matrix = new Matrix();
	var bitmap:BitmapData;

	public function new(bitmap:BitmapData) {
		super();
		this.bitmap = bitmap;
		offset_matrix.ty = 12;
	}

	public function draw() {
		visible = active;
		if (!active) return;
		offset_matrix.tx += 4;
		graphics.clear();
		graphics.beginBitmapFill(bitmap, offset_matrix, true, true);
		graphics.drawRect(0, -12, length, 24);
		graphics.endFill();
	}
	
}