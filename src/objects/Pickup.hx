package objects;

import scenes.Level;
import openfl.events.MouseEvent;

class Pickup extends GameObject {

	public function new(x:Int, y:Int, title:String) {
		super(x, y, { current: 0, max: 0 }, title);
		draw_pickup();
		addEventListener(MouseEvent.MOUSE_DOWN, mouse_down);
		Level.i.objects.addChild(this);
	}

	function draw_pickup() {}
	function mouse_down(e:MouseEvent) trace('Pickup Clicked!');

}