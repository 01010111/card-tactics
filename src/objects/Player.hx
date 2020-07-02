package objects;

import util.TurnUtil;
import ui.MutantCard;
import ui.EquipmentCard;
import zero.utilities.Color;
import openfl.display.Sprite;
import objects.Actor.ActorData;
import ui.GearCard;
import openfl.events.MouseEvent;
import ui.Equipment;
import scenes.Level;
import zero.openfl.utilities.AnimatedSprite;
import util.EquipmentUtil;

class Player extends Actor {

	public static var selected_player(default, set):Player;

	public var AP(default, set):Int = 10;
	function set_AP(n:Int) {
		AP = n;
		equipment.player_info.update_ap_pts();
		return AP;
	}

	public function new(x:Int, y:Int, options:PlayerOptions) {
		super(options.data, x, y);
		addEventListener(MouseEvent.CLICK, (e) -> if (Level.i.can_move && TurnUtil.player_turn) selected_player = this);
		Level.i.objects.add(this);
		Level.i.dolly.follow_object(this, true);
		Level.i.object_map[y][x] = -1;

		init_graphic();
		
		equipment = new Equipment(this, options.side);
		for (id in options.data.equipment) {
			switch EquipmentUtil.id_type(id) {
				case NONE:continue;
				case GEAR:equipment.add_card(new GearCard(equipment, EquipmentUtil.get_gear_data(id)));
				case MUTANT:equipment.add_card(new MutantCard(equipment, EquipmentUtil.get_mutant_data(id)));
			}
		}
		Level.i.gear_layer.add(equipment);
	}

	function init_graphic() {
		graphic = new AnimatedSprite({
			source: 'images/players.png',
			animations: [],
			frame_width: 16,
			frame_height: 16,
			offset_x: 8,
			offset_y: 12,
		});
		graphic.set_frame_index(8.get_random().floor());
		addChild(graphic);
	}

	static function set_selected_player(player:Player) {
		Equipment.active_equipment = player.equipment;
		Level.i.clear_indicators();
		Level.i.dolly.follow_object(player, false);
		player.pulse();
		player.equipment.move_card.set_moves();
		return selected_player = player;
	}

	override function health_callback() {
		equipment.player_info.update_health();
	}

	override function set_shield(amt:Int):Int {
		super.set_shield(amt);
		equipment.player_info.update_shield();
		return shield;
	}

}

typedef PlayerOptions = {
	data:ActorData,
	side:PlayerSide,
}

enum PlayerSide {
	LEFT;
	RIGHT;
}