package objects;

import openfl.display.Sprite;

class CardContainer extends Sprite {
	public static var i:CardContainer;
	public function new() {
		super();
		i = this;
	}
}