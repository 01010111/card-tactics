package objects;

import zero.utilities.IntPoint;
import ui.EquipmentSprite;
import ui.InventorySprite;
import openfl.geom.Point;
import zero.openfl.utilities.Game;
import data.Inventory;
import ui.GearSprite;
import zero.openfl.utilities.AnimatedSprite;
import util.EquipmentUtil;
import zero.utilities.Ease;
import zero.utilities.Tween;
import ui.CancelButton;
import data.Gear;

class GearPickup extends Pickup {
	
	var data:GearData;

	public function new(x:Int, y:Int, title:String) {
		data = EquipmentUtil.get_gear_data(title);
		super(x, y, title);
	}

	override function mouse_down() {
		if (GAMESTATE != USING_GEAR) return;
		var pos = parent.parent.localToGlobal(new Point(x, y));
		var gear:GearSprite = cast new GearSprite(new Gear(new Inventory(this), 0, data)).set_position(pos.x, pos.y);
		gear.home = [Game.width - 32 - EquipmentSprite.WIDTH/2, Game.height - 96 - EquipmentSprite.HEIGHT/2];
		gear.draggable = true;
		Tween.get(gear).from_to('scaleX', 0.25, 1).from_to('scaleY', 0.25, 1).ease(Ease.backOut).duration(0.4);
		LEVEL.info_layer.add(gear);
		this.remove();
		gear.active = true;
		GearSprite.PLACEABLE_GEAR = gear;
		GAMESTATE = PLACING_GEAR;

		LEVEL.info_layer.add(new CancelButton('Put Back', () -> {
			gear.remove();
			GearSprite.PLACEABLE_GEAR = null;
			new GearPickup(this.pos.x, this.pos.y, data.id);
			GAMESTATE = USING_GEAR;
			LEVEL.clear_indicators();
		}, GET_GEAR));
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
		graphic.frame_index = 2;
		this.add(graphic);
		Tween.get(this).from_to('scaleX', 0, 1).from_to('scaleY', 0, 1).ease(Ease.elasticOut);
	}

}