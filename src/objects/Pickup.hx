package objects;

import zero.utilities.IntPoint;
import scenes.Level;
import openfl.events.MouseEvent;

class Pickup extends GameObject {

	var pos:IntPoint;

	public function new(x:Int, y:Int, title:String) {
		super(x, y, { current: 0, max: 0 }, title);
		pos = [x, y];
		draw_pickup();
		addEventListener(MouseEvent.MOUSE_DOWN, (e) -> if (GAMESTATE == USING_GEAR) mouse_down());
		LEVEL.objects.addChild(this);
	}

	function draw_pickup() {}
	function mouse_down() {}

}

enum PickupType {
	GEAR;
	MEAT;
	SHIELD;
}