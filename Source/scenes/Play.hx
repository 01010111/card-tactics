package scenes;

import zero.utilities.Color;
import objects.Tilemap;
import openfl.display.Sprite;

class Play extends Scene {

	public function new() {
		super();
		var bg = new Sprite();
		bg.fill_rect(Color.PICO_8_WHITE, -Game.width, -Game.height, Game.width * 2, Game.height * 2);
		bg.x = Game.width/2;
		bg.y = Game.height/2;
		addChild(bg);
		bg.add(new ThreeDeeTest({
			graphic: 'assets/images/car.png',
			frame_size: [16, 16],
			position: [0, 0]
		}));
		Tween.get(bg).prop({rotation:360}).duration(5).type(LOOP_FORWARDS);
	}

}