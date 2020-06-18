package ui;

import scenes.Level;
import ui.GearCard;
import objects.GameObject;
import openfl.display.Sprite;

using zero.openfl.extensions.SpriteTools;

class InfoLayer extends Sprite {

	var object_info:ObjectInfo;

	public function new() {
		super();
		this.add(object_info = new ObjectInfo());
	}

	public function show_info(object:GameObject, ?gear:GearCard) {
		var cards = [for (card in object.equipment.gear_cards) if (card.equipment_data.effect.type == DAMAGE) card];
		Level.i.draw_indicators(cards);
		object_info.set_target(object, gear);
		object_info.active = true;
	}

	public function hide_info(clear_indicators:Bool = true) {
		object_info.active = false;
		if (clear_indicators) Level.i.clear_indicators();
	}

}