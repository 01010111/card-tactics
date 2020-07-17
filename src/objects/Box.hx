package objects;

import objects.Pickup.PickupType;
import data.Inventory;
import zero.openfl.utilities.AnimatedSprite;
import scenes.Level;

class Box extends GameObject {

	public function new(x:Int, y:Int) {
		super(x, y, { current: 10, max: 10 }, 'Box');
		LEVEL.objects.add(this);
		init_graphic();
	}

	function init_graphic() {
		graphic = new AnimatedSprite({
			source: 'images/objects.png',
			animations: [],
			frame_width: 16,
			frame_height: 24,
			offset_x: 8,
			offset_y: 16,
		});
		graphic.set_frame_index(0);
		addChild(graphic);
	}

	override function kill() {
		super.kill();
	}

	override function drop(x:Int, y:Int) {
		var loot = util.LootUtil.get();
		if (loot == null) return;
		switch loot.type {
			case GEAR: new GearPickup(x, y, loot.id);
			case MEAT: new MeatPickup(x, y, loot.amt);
			case SHIELD: new ShieldPickup(x, y, loot.amt);
		}
	}

}