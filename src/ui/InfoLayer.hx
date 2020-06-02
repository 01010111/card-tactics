package ui;

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
		object_info.set_target(object, gear);
		object_info.active = true;
	}

	public function hide_info() {
		object_info.active = false;
	}

}