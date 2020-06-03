package objects;

import objects.Actor.ActorData;
import ui.GearCard;
import openfl.events.MouseEvent;
import ui.Gear;
import scenes.Level;
import zero.openfl.utilities.AnimatedSprite;
import util.GearUtil;

using zero.extensions.Tools;
using zero.openfl.extensions.SpriteTools;
using Math;

class Player extends Actor {

	public static var selected_player(default, set):Player;

	public var AP(default, set):Int = 10;
	function set_AP(n:Int) {
		AP = n;
		gear.player_info.update_ap_pts();
		return AP;
	}

	var gear:Gear;

	public function new(x:Int, y:Int, options:PlayerOptions) {
		super(options.data, x, y);
		addEventListener(MouseEvent.CLICK, (e) -> if (Level.i.can_move) selected_player = this);
		Level.i.objects.add(this);
		Level.i.dolly.follow(this, true);
		Level.i.object_map[y][x] = -1;

		init_graphic();
		
		gear = new Gear(this, options.side);
		for (g in options.data.gear) gear.add_card(new GearCard(gear, GearUtil.get_gear_data(g)));
		Level.i.gear_layer.add(gear);
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
		Gear.active_gear = player.gear;
		Level.i.dolly.follow(player, false);
		player.pulse();
		return selected_player = player;
	}

	override function health_callback() {
		gear.player_info.update_health();
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