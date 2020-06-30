package objects;

import zero.utilities.Ease;
import zero.utilities.Tween;
import zero.utilities.Color;
using zero.openfl.extensions.SpriteTools;

class GearPickup extends Pickup {

	override function draw_pickup() {
		this.fill_rect(Color.PICO_8_RED, -4, -4, 8, 8, 2);
		Tween.get(this).from_to('scaleX', 0, 1).from_to('scaleY', 0, 1).ease(Ease.elasticOut);
	}

}