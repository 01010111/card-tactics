package objects;

import zero.utilities.Color;
import ui.InventorySprite;
import ui.PlayerInfo;
import data.Mutation;
import data.Gear;
import objects.Actor.ActorData;
import openfl.events.MouseEvent;
import scenes.Level;
import zero.openfl.utilities.AnimatedSprite;
import util.EquipmentUtil;

class Player extends Actor {

	public static var selected_player(default, set):Player;

	override function set_AP(n:Int) {
		AP = n;
		player_info.update_ap_pts();
		return AP;
	}

	var player_info:PlayerInfo;

	public function new(x:Int, y:Int, options:PlayerOptions) {
		super(options.data, x, y);
		addEventListener(MouseEvent.CLICK, (e) -> if (GAMESTATE != ENEMY_TURN) selected_player = this);
		LEVEL.objects.add(this);
		LEVEL.dolly.follow_object(this, true);

		init_graphic();
		var i = -1;
		for (id in options.data.equipment) {
			i++;
			if (id == null) continue;
			switch EquipmentUtil.id_type(id) {
				case NONE: continue;
				case GEAR: inventory.add_equipment(new Gear(inventory, i, EquipmentUtil.get_gear_data(id)));
				case MUTANT: inventory.add_equipment(new Mutation(inventory, i, EquipmentUtil.get_mutant_data(id)));
			}
		}
		LEVEL.gear_layer.add(player_info = new PlayerInfo(this, options.side));
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
		InventorySprite.active_inventory = player.inventory.sprite;
		selected_player = player;
		LEVEL.clear_indicators();
		LEVEL.dolly.follow_object(player, false);
		player.pulse();
		player.inventory.movement.set_moves();
		return player;
	}

	override function health_callback() {
		player_info.update_health();
	}

	override function set_shield(amt:Int):Int {
		super.set_shield(amt);
		player_info.update_shield();
		return shield;
	}

	override function change_health(delta:Int) {
		if (delta < 0) LEVEL.dolly.flash(Color.PICO_8_RED, 0.25, 0.25);
		super.change_health(delta);
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