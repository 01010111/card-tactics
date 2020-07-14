package ui;

import data.Equipment;
import scenes.Level;
import objects.GameObject;
import openfl.display.Sprite;

class InfoLayer extends Sprite {

	var object_info:ObjectInfo;

	public function new() {
		super();
		this.add(object_info = new ObjectInfo());
	}

	public function show_info(object:GameObject, draw_indicators:Bool = true, ?equipment:Equipment) {
		if (object.is(objects.Pickup)) return;
		var cards = [for (card in object.inventory.equipment) if (!card.expended && card.data.effect.type == DAMAGE) card];
		if (draw_indicators) LEVEL.draw_indicators(cards);
		object_info.set_target(object, equipment);
		object_info.active = true;
	}

	public function hide_info(clear_indicators:Bool = true) {
		object_info.active = false;
		if (clear_indicators) LEVEL.clear_indicators();
	}

}