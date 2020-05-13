package objects;

import zero.utilities.Timer;
import openfl.display.Bitmap;
import openfl.geom.Rectangle;
import openfl.Assets;
import zero.utilities.IntPoint;
import openfl.display.BitmapData;
import zero.utilities.Vec2;
import openfl.display.Sprite;

class ThreeDeeTest extends GameObject {

	var stack:Array<Sprite> = [];
	public var position(get, set):Vec2;
	function get_position():Vec2 {
		return [x, y];
	}
	function set_position(v:Vec2) {
		x = v.x;
		y = v.y;
		return v;
	}

	public var scale(get, set):Vec2;
	function get_scale():Vec2 {
		return [scaleX, scaleY];
	}
	function set_scale(v:Vec2) {
		scaleX = v.x;
		scaleY = v.y;
		return v;
	}

	public function new(options:StackOptions) {
		super();
		var bitmap_data = Assets.getBitmapData(options.graphic);
		init_stack(bitmap_data, options.frame_size);
		filters = [new openfl.filters.DropShadowFilter(0, 0, 0x000000, 1, 8, 8, 255)];
		position = options.position;
		scale = [8, 8];
	}

	function init_stack(bitmap_data:BitmapData, frame_size:IntPoint) {
		var offset = 0;
		for (j in 0...(bitmap_data.height/frame_size.y).floor()) for (i in 0...(bitmap_data.width/frame_size.x).floor()) {
			var bd = new BitmapData(frame_size.x, frame_size.y, true, 0x00000000);
			bd.copyPixels(bitmap_data, new Rectangle(i * frame_size.x, j * frame_size.y, frame_size.x, frame_size.y), new openfl.geom.Point(0, 0));
			var bitmap = new Bitmap(bd);
			bitmap.y = -frame_size.y/2;
			bitmap.x = -frame_size.x/2;
			var sprite = new Sprite();
			sprite.addChild(bitmap);
			addChild(sprite);
			stack.push(sprite);
		}
	}

	override function update(?dt:Float) {
		super.update(dt);
		var offset:Vec2 = [0,1];
		trace(parent.rotation);
		offset.angle = -(parent.rotation + 90);
		for (i in 0...stack.length) {
			var sprite = stack[i];
			if (i == 0) continue;
			sprite.x = offset.x;
			sprite.y = offset.y;
			offset.length += 1;
		}
	}

}

typedef StackOptions = {
	position:Vec2,
	graphic:String,
	frame_size:IntPoint,
}