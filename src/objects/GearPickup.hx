package objects;

import openfl.events.MouseEvent;
import util.EquipmentUtil;
import zero.utilities.Ease;
import zero.utilities.Tween;
import zero.utilities.Color;
import ui.GearCard;

class GearPickup extends Pickup {
	
	var data:GearData;

	public function new(x:Int, y:Int, title:String) {
		data = EquipmentUtil.get_gear_data(title);
		super(x, y, title);
	}

	override function mouse_down() {
		trace(data);
		Tween.get(this).from_to('rotation', -360, 0).ease(Ease.backInOut);
	}

	override function draw_pickup() {
		this.fill_rect(Color.PICO_8_RED, -4, -4, 8, 8, 2);
		Tween.get(this).from_to('scaleX', 0, 1).from_to('scaleY', 0, 1).ease(Ease.elasticOut);
	}

}