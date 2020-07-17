package objects;

import zero.utilities.Ease;
import zero.utilities.Tween;
import zero.openfl.utilities.AnimatedSprite;

class ShieldPickup extends Pickup {

	var amt:Int;

	public function new(x:Int, y:Int, amt:Int) {
		super(x, y, 'shield');
		this.amt = amt;
	}

	override function mouse_down() {
		Player.selected_player.shield += amt;
		this.remove();
	}

	override function draw_pickup() {
		var graphic = new AnimatedSprite({
			source: 'images/pickups.png',
			frame_width: 16,
			frame_height: 16,
			offset_x: 8,
			offset_y: 8,
			animations: []
		});
		graphic.frame_index = 1;
		this.add(graphic);
		Tween.get(this).from_to('scaleX', 0, 1).from_to('scaleY', 0, 1).ease(Ease.elasticOut);
	}

}