package scenes;

import zero.openfl.utilities.AnimatedSprite;
import zero.openfl.utilities.Dolly;
import zero.openfl.utilities.Tilemap;
import openfl.Assets;
import openfl.events.Event;
import zero.utilities.IntPoint;
import openfl.events.MouseEvent;
import openfl.display.Sprite;
import zero.openfl.utilities.Scene;
import zero.utilities.Tween;

using Math;
using zero.openfl.extensions.SpriteTools;
using zero.utilities.AStar;
using zero.utilities.OgmoUtils;
using zero.extensions.FloatExt;

class Level extends Scene {

	var tiles:Tilemap;
	var object_map:Array<Array<Int>> = [];
	var players:Array<Sprite> = [];
	var tweens:Map<Sprite,Tween> = [];
	var selected_player(default, set):PlayerSprite;
	var can_move:Bool = true;
	var dolly:Dolly;
	var objects:Sprite;

	function set_selected_player(player:PlayerSprite) {
		dolly.follow(player, false);
		player.pulse();
		return selected_player = player;
	}
	
	public function new() {
		super();
		zoom = 3;
	}

	override function create() {
		super.create();
		dolly = new Dolly();
		objects = new Sprite();
		addChild(dolly);
		draw_map('000');
		dolly.add(objects);
		make_player(2, 9);
		make_player(6, 8);
		addEventListener(MouseEvent.CLICK, on_click);
		addEventListener(Event.ENTER_FRAME, (e) -> {
			Tween.update(1/60);
			dolly.update(1/60);
		});
	}

	function draw_map(src:String) {
		var project = OgmoUtils.parse_project_json(Assets.getText('data/maps/maps.ogmo'));
		var level = OgmoUtils.parse_level_json(Assets.getText('data/maps/$src.json'));
		tiles = new Tilemap({ map: level.get_tile_layer('tiles').data2D, tileset: { image: 'images/tiles.png', frame_height: 16, frame_width: 16 }, smoothing: false, solids: [for (i in 64...256) i] });
		dolly.addChild(tiles);
		object_map = [for (row in tiles.get_map(false)) [for (n in row) 0]];
	}
	
	function make_player(x:Int, y:Int) {
		var player = new PlayerSprite(x * 16 + 8, y * 16 + 8);
		player.addEventListener(MouseEvent.CLICK, (e) -> if (can_move) selected_player = player);
		objects.addChild(player);
		players.push(player);
		selected_player = player;
		dolly.follow(selected_player, true);
		object_map[y][x] = -1;
	}

	function on_click(e:MouseEvent) {
		if (!can_move || e.localX < 0 || e.localY < 0) return;
		if (tweens.exists(selected_player) && tweens[selected_player].active) tweens[selected_player].destroy();
		var x = (e.localX/16).floor();
		var y = (e.localY/16).floor();
		var map = get_traversal_map();
		if (map[y][x] != 0) return;
		var player_x = (selected_player.x/16).floor();
		var player_y = (selected_player.y/16).floor();
		var path = map.get_path({
			start: [player_x, player_y],
			end: [x, y],
			passable: [0],
			simplify: NONE,
		});
		if (path.length == 0) return;
		object_map[player_y][player_x] = 0;
		object_map[y][x] = -1;
		follow_path(selected_player, path);
		can_move = false;
	}

	function get_traversal_map():Array<Array<Int>> {
		var out = tiles.get_solids_array();
		for (j in 0...object_map.length) for (i in 0...object_map[j].length) if (object_map[j][i] != 0) out[j][i] = 1;
		return out;
	}

	function follow_path(player:PlayerSprite, path:Array<IntPoint>) {
		var t = path.shift();
		var tween = Tween.get(selected_player).from_to('x', selected_player.x, t.x * 16 + 8).from_to('y', selected_player.y, t.y * 16 + 8).duration(0.05).on_complete(() -> {
			if (path.length > 0) follow_path(player, path);
			else {
				player.pulse();
				can_move = true;
			}
		});
		tween.update_tween(1/60);
		tweens.set(selected_player, tween);
		return true;
	}

}

class PlayerSprite extends Sprite {

	var last_x:Float;
	var last_y:Float;
	var graphic:AnimatedSprite;

	public function new(x:Float, y:Float) {
		super();
		
		this.set_position(x, y);
		last_x = x;
		last_y = y;
		addEventListener(Event.ENTER_FRAME, (e) -> update(1/60));
		init_graphic();
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
		graphic.set_frame_index(16.get_random().floor());
		addChild(graphic);
	}

	function update(dt:Float) {
		var rot = last_x == x ? 0 : (last_x - x).sign_of() * 15;
		rotation += (rot - rotation) * 0.25;
		if (rot.abs() > 0) graphic.scaleX = -rot.sign_of();
		last_x = x;
	}

	public function pulse() {
		Tween.get(this).from_to('scaleX', 1.5, 1).from_to('scaleY', 0.5, 1).ease(zero.utilities.Ease.elasticOut).duration(0.5);
	}

}