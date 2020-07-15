package objects;

import scenes.Level;
import openfl.events.MouseEvent;

class Pickup extends GameObject {

	public function new(x:Int, y:Int, title:String) {
		super(x, y, { current: 0, max: 0 }, title);
		draw_pickup();
		addEventListener(MouseEvent.MOUSE_DOWN, (e) -> if (GAMESTATE == USING_GEAR) mouse_down());
		LEVEL.objects.addChild(this);
	}

	function draw_pickup() {}
	function mouse_down() {}

}