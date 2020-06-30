package ui;

import scenes.Level;
import ui.GearCard;
import objects.GameObject;
import openfl.display.Sprite;

using zero.openfl.extensions.SpriteTools;
using Std;

class InfoLayer extends Sprite {

	var object_info:ObjectInfo;

	public function new() {
		super();
		this.add(object_info = new ObjectInfo());
	}

	public function show_info(object:GameObject, draw_indicators:Bool = true, ?equipment:EquipmentCard) {
		if (object.is(objects.Pickup)) return;
		var cards = [for (card in object.equipment.equipment_cards) if (!card.expended && card.equipment_data.effect.type == DAMAGE) card];
		if (draw_indicators) Level.i.draw_indicators(cards);
		object_info.set_target(object, equipment);
		object_info.active = true;
	}

	public function hide_info(clear_indicators:Bool = true) {
		object_info.active = false;
		if (clear_indicators) Level.i.clear_indicators();
	}

}