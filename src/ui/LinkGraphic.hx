package ui;

import openfl.Assets;
import openfl.display.Sprite;
import openfl.geom.Matrix;

class LinkGraphic extends Sprite {

	public var length:Float = 8;
	public var active:Bool = false;

	var offset_matrix:Matrix = new Matrix();

	public function new() {
		super();
		offset_matrix.ty = 12;
	}

	public function draw() {
		visible = active;
		if (!active) return;
		offset_matrix.tx += 4;
		graphics.clear();
		graphics.beginBitmapFill(Assets.getBitmapData('images/ui/action_arrow_white.png'), offset_matrix, true, true);
		graphics.drawRect(0, -12, length, 24);
		graphics.endFill();
	}
	
}