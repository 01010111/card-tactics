package objects;

import data.Inventory;
import zero.openfl.utilities.AnimatedSprite;
import scenes.Level;

class Box extends GameObject {

	public function new(x:Int, y:Int) {
		super(x, y, { current: 10, max: 10 }, 'Box');
		LEVEL.objects.add(this);
		init_graphic();
	}

	function init_graphic() {
		graphic = new AnimatedSprite({
			source: 'images/objects.png',
			animations: [],
			frame_width: 16,
			frame_height: 16,
			offset_x: 8,
			offset_y: 10,
		});
		graphic.set_frame_index(0);
		addChild(graphic);
	}

}