package scenes;

import zero.utilities.Color;
import ui.cards.GearCard;
import zero.openfl.utilities.Particles;
import zero.openfl.utilities.Dolly;
import zero.openfl.utilities.Tilemap;
import openfl.Assets;
import openfl.events.Event;
import zero.utilities.IntPoint;
import openfl.events.MouseEvent;
import openfl.display.Sprite;
import zero.openfl.utilities.Scene;
import zero.utilities.Tween;
import particles.Poof;
import ui.InfoLayer;
import objects.Player;

using Math;
using zero.openfl.extensions.SpriteTools;
using zero.utilities.AStar;
using zero.utilities.OgmoUtils;
using zero.utilities.EventBus;
using zero.extensions.Tools;

class Level extends Scene {

	public static var i:Level;

	var tiles:Tilemap;
	var object_map:Array<Array<Int>> = [];
	var selected_player(default, set):Player;
	public var can_move:Bool = true;
	public var dolly:Dolly;

	// layers
	public var level:Sprite;
	public var indicators:Sprite;
	public var under_objects:Sprite;
	public var objects:Sprite;
	public var over_objects:Sprite;
	public var info_layer:InfoLayer;

	// Particles
	public var poofs:Particles = new Particles(() -> new Poof());

	function set_selected_player(player:Player) {
		dolly.follow(player, false);
		player.pulse();
		return selected_player = player;
	}
	
	public function new() {
		i = this;
		super();
	}

	override function create() {
		super.create();
		init_dolly();
		draw_map('000');
		var player = make_player(2, 9);
		player.change_health(-16);
		make_player(6, 8);
		dolly.update.listen('update');
		var gear = new ui.cards.Gear(player);
		var deck = new ui.cards.Deck();
		this.add(gear);
		gear.add_card(new ui.cards.GearCard(240, 144, gear, {
			title: 'Test Card',
			cost: 3,
			description: 'A test card',
			range: {
				min: 3,
				max: 6,
				type: NONE,
			},
			gear_class: FLAME,
			weakness: PIERCING,
			requirement: DIFF_SUIT,
			requirement_value: 3,
			effect: {
				type: DAMAGE,
				factor: VALUES,
			},
			bonus: {
				requirement: CLUBS,
				type: DOUBLE_EFFECT_VALUE
			}
		}));
		gear.add_card(new ui.cards.GearCard(448, 144, gear, {
			title: 'Test Utility Card',
			cost: 2,
			description: 'A test utility card',
			range: {
				min: 0,
				max: 3,
				type: NONE,
			},
			gear_class: HEALTH,
			weakness: EXPLOSIVE,
			requirement: IS_FACE,
			effect: {
				type: HEALTH,
				factor: STATIC,
				value: 5
			},
			bonus: {
				requirement: TWO_CARDS,
				type: DOUBLE_EFFECT_VALUE
			},
		}));
		this.add(deck);
		deck.deal();
		this.add(info_layer = new InfoLayer());
	}

	function init_dolly() {
		this.add(dolly = new Dolly());
		dolly.add(level = new Sprite());
		dolly.add(indicators = new Sprite());
		dolly.add(under_objects = new Sprite());
		dolly.add(objects = new Sprite());
		dolly.add(over_objects = new Sprite());
		dolly.set_scale(3);
	}

	function draw_map(src:String) {
		var level_data = OgmoUtils.parse_level_json(Assets.getText('data/maps/$src.json'));
		tiles = new Tilemap({ map: level_data.get_tile_layer('tiles').data2D, tileset: { image: 'images/tiles.png', frame_height: 16, frame_width: 16 }, smoothing: false, solids: [for (i in 64...256) i] });
		level.add(tiles);
		level.addEventListener(MouseEvent.CLICK, on_click);
		object_map = [for (row in tiles.get_map(false)) [for (n in row) 0]];
	}
	
	function make_player(x:Int, y:Int) {
		var player = new Player(x * 16 + 8, y * 16 + 8);
		player.addEventListener(MouseEvent.CLICK, (e) -> if (can_move) selected_player = player);
		player.addEventListener(MouseEvent.MOUSE_OVER, (e) -> info_layer.show_info(player));
		player.addEventListener(MouseEvent.MOUSE_OUT, (e) -> info_layer.hide_info());
		objects.add(player);
		selected_player = player;
		dolly.follow(selected_player, true);
		object_map[y][x] = -1;
		return player;
	}

	function on_click(e:MouseEvent) {
		if (!can_move || e.localX < 0 || e.localY < 0) return;
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
		selected_player.follow_path(path);
		can_move = false;
	}

	function get_traversal_map():Array<Array<Int>> {
		var out = tiles.get_solids_array();
		for (j in 0...object_map.length) for (i in 0...object_map[j].length) if (object_map[j][i] != 0) out[j][i] = 1;
		return out;
	}


	public function clear_indicators() {
		indicators.graphics.clear();
	}

	public function draw_indicators(gear_card:GearCard) {
		trace('indicators');
		indicators.graphics.clear();
		var player = gear_card.gear.player;
		var range = gear_card.data.range;
		if (gear_card.data.bonus.type == DOUBLE_RANGE && gear_card.vefify_bonus()) range.max *= 2;
		var tiles = get_available_tiles_array([(player.x/16).floor(), (player.y/16).floor()], range.min, range.max);
		var color = switch gear_card.data.effect.type {
			case DAMAGE:Color.PICO_8_RED;
			case MOVE:Color.PICO_8_BLUE;
			case HEALTH:Color.PICO_8_GREEN;
			case SHIELD:Color.PICO_8_ORANGE;
		}
		var color_fill:Color = cast color.copy();
		color_fill.alpha = 0.25;
		for (tile in tiles) indicators.fill_rect(color_fill, tile.x * 16 + 2, tile.y * 16 + 2, 12, 12, 2).rect(color, tile.x * 16 + 2, tile.y * 16 + 2, 12, 12, 2, 1);
	}

	function get_available_tiles_array(origin:IntPoint, min_range:Int, max_range:Int, restrictions:RangeType = NONE) {
		var solids = tiles.get_solids_array([for (i in 128...256) i]);
		var not_availables = tiles.get_solids_array();
		var map = solids.heat_map(origin.x, origin.y, max_range);
		var out:Array<IntPoint> = [];
		for (j in 0...map.length) for (i in 0...map[j].length) if (map[j][i] > 0) {
			if (map[j][i] > max_range - min_range) map[j][i] = 0;
			else if (not_availables[j][i] != 0) map[j][i] = 0;
			else if (!AStar.los(origin, [i, j], solids, [0])) map[j][i] = 0;
			if (map[j][i] > 0) out.push([i, j]);
		}
		for (row in map) trace(row);
		return out;
	}

}