package scenes;

import ui.Deck;
import zero.utilities.Color;
import ui.GearCard;
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
	public var object_map:Array<Array<Int>> = [];
	public var can_move:Bool = true;
	public var dolly:Dolly;
	public var available_tiles:Array<IntPoint>;

	// layers
	public var level:Sprite;
	public var indicators:Sprite;
	public var under_objects:Sprite;
	public var objects:Sprite;
	public var over_objects:Sprite;
	public var gear_layer:Sprite;
	public var deck:Deck;
	public var info_layer:InfoLayer;

	// Particles
	public var poofs:Particles = new Particles(() -> new Poof());

	public function new() {
		i = this;
		super();
	}

	override function create() {
		super.create();
		init_dolly();
		draw_map('000');
		dolly.update.listen('update');
		deck = new Deck();
		this.add(gear_layer = new Sprite());
		this.add(deck);
		deck.deal();
		this.add(info_layer = new InfoLayer());
		var player = new Player(2, 9, {
			data: {
				id: 'Test Player',
				health: {
					current: 48,
					max: 64,
				},
				movement: {
					requirement: MAX_CARD,
					value: 5,
					type: FREE,
					factor: VALUE,
				},
				gear: ['test_d_01', 'test_h_01'],
			},
			side: LEFT,
		});
		new Player(6, 8, {
			data: {
				id: 'Test Player',
				health: {
					current: 64,
					max: 64,
				},
				movement: {
					requirement: MAX_CARD,
					value: 5,
					type: FREE,
					factor: VALUE,
				},
				gear: ['test_u_01', 'test_h_01'],
			},
			side: RIGHT,
		});
		Player.selected_player = player;
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

	function on_click(e:MouseEvent) {
		if (!can_move || e.localX < 0 || e.localY < 0) return;
		var x = (e.localX/16).floor();
		var y = (e.localY/16).floor();
		'level_click'.dispatch({ x: x, y: y });
		var map = get_traversal_map();
		if (map[y][x] != 0) return;
		var player_x = (Player.selected_player.x/16).floor();
		var player_y = (Player.selected_player.y/16).floor();
		var path = map.get_path({
			start: [player_x, player_y],
			end: [x, y],
			passable: [0],
			simplify: NONE,
		});
		if (path.length == 0) return;
		object_map[player_y][player_x] = 0;
		object_map[y][x] = -1;
		Player.selected_player.follow_path(path);
		can_move = false;
	}

	public function get_traversal_map():Array<Array<Int>> {
		var out = tiles.get_solids_array();
		for (j in 0...object_map.length) for (i in 0...object_map[j].length) if (object_map[j][i] != 0) out[j][i] = 1;
		return out;
	}

	public function clear_indicators() {
		indicators.graphics.clear();
	}

	public function draw_indicators(gear_card:GearCard) {
		indicators.graphics.clear();
		var player = gear_card.gear.player;
		var range = gear_card.gear_data.range;
		if (gear_card.gear_data.bonus.type == DOUBLE_RANGE && gear_card.vefify_bonus()) range.max *= 2;
		var tiles = get_available_tiles_array([(player.x/16).floor(), (player.y/16).floor()], range.min, range.max);
		var color = switch gear_card.gear_data.effect.type {
			default: Color.WHITE;
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
		available_tiles = out;
		return out;
	}

}