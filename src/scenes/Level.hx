package scenes;

import ui.InventorySprite;
import data.Gear;
import ui.GearSprite;
import data.Movement;
import data.Equipment;
import zero.openfl.utilities.Keys;
import util.TurnUtil;
import zero.openfl.utilities.Game;
import ui.Deck;
import zero.utilities.Color;
import zero.openfl.utilities.Particles;
import objects.Dolly;
import zero.openfl.utilities.Tilemap;
import openfl.Assets;
import zero.utilities.IntPoint;
import openfl.events.MouseEvent;
import openfl.display.Sprite;
import zero.openfl.utilities.Scene;
import particles.Poof;
import ui.InfoLayer;
import objects.Player;

using zero.utilities.AStar;
using zero.utilities.OgmoUtils;

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
	public var move_indicators:Sprite;
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
		((?_) -> if (Keys.just_pressed(84)) TurnUtil.player_turn = !TurnUtil.player_turn).listen('update');
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
					requirement_value: 5,
					type: FREE,
					factor: VALUE,
				},
				equipment: ['test_d_02', 'test_m_01', 'test_m_02'],
			},
			side: LEFT,
		});
		var player2 = new Player(6, 8, {
			data: {
				id: 'Test Player',
				health: {
					current: 64,
					max: 64,
				},
				movement: {
					requirement: MAX_CARD,
					requirement_value: 5,
					type: FREE,
					factor: VALUE,
				},
				equipment: ['test_d_01', 'test_u_01', 'test_h_01'],
			},
			side: RIGHT,
		});
		Player.selected_player = player;
		player2.shield = 4;
		var pickup = new objects.GearPickup(4, 10, 'test_u_01');
	}

	function init_dolly() {
		this.add(dolly = new Dolly());
		dolly.add(level = new Sprite());
		dolly.add(indicators = new Sprite());
		dolly.add(move_indicators = new Sprite());
		dolly.add(under_objects = new Sprite());
		dolly.add(objects = new Sprite());
		dolly.add(over_objects = new Sprite());
		dolly.set_scale(3);
		move_indicators.addEventListener(MouseEvent.CLICK, on_click);
		level.addEventListener(MouseEvent.MOUSE_DOWN, level_mouse_down);
		Game.root.stage.addEventListener(MouseEvent.MOUSE_UP, level_mouse_up);
	}

	function level_mouse_down(e:MouseEvent) {
		if (!TurnUtil.player_turn) return;
		dolly.startDrag(false);
		dolly.following = false;
	}

	function level_mouse_up(e:MouseEvent) {
		dolly.stopDrag();
	}

	function draw_map(src:String) {
		var level_data = OgmoUtils.parse_level_json(Assets.getText('data/maps/$src.json'));
		tiles = new Tilemap({ map: level_data.get_tile_layer('tiles').data2D, tileset: { image: 'images/tiles.png', frame_height: 16, frame_width: 16 }, smoothing: false, solids: [for (i in 64...256) i] });
		level.add(tiles);
		object_map = [for (row in tiles.get_map(false)) [for (n in row) 0]];
	}

	function on_click(e:MouseEvent) {
		trace('on click');
		if (!can_move || e.localX < 0 || e.localY < 0) return;
		trace('pass');
		var x = (e.localX/16).floor();
		var y = (e.localY/16).floor();
		Player.selected_player.move_to(x, y);
		can_move = false;
		move_indicators.graphics.clear();
		InventorySprite.active_inventory.inventory.movement.execute();
	}

	public function get_traversal_map(?ignore:IntPoint):Array<Array<Int>> {
		var out = tiles.get_solids_array();
		for (j in 0...object_map.length) for (i in 0...object_map[j].length) if (object_map[j][i] != 0) out[j][i] = 1;
		if (ignore != null) out[ignore.y][ignore.x] = 0;
		return out;
	}

	public function clear_indicators() {
		indicators.graphics.clear();
		move_indicators.visible = true;
	}

	public function draw_indicators(?equipment:Equipment, ?equipment_array:Array<Equipment>) {
		var equips = equipment_array == null ? equipment == null ? [] : [equipment] : equipment_array;
		indicators.graphics.clear();
		move_indicators.visible = false;
		var placed_tiles:Array<IntPoint> = [];
		for (eq in equips) {
			var object = eq.inventory.owner;
			var range:RangeData = {
				min: eq.data.range.min,
				max: eq.data.range.max,
				type: eq.data.range.type
			};
			if (eq.is(Gear) && (cast eq:Gear).verify_bonus()) {
				var gear:Gear = cast eq;
				switch gear.gear_data.bonus.type {
					case DOUBLE_RANGE: range.max *= 2;
					case RANGE_PLUS_ONE: range.max += 1;
					case RANGE_PLUS_TWO: range.max += 2;
					case DOUBLE_EFFECT_VALUE, EFFECT_PLUS_ONE, EFFECT_PLUS_TWO: {};
				}
			}
			if (range.type == DIAGONAL) {
				range.min *= 2;
				range.max *= 2;
			}
			var tiles = get_available_tiles_array([(object.x/16).floor(), (object.y/16).floor()], range.min, range.max, range.type);
			var color = switch eq.data.effect.type {
				default: Color.WHITE;
				case DAMAGE:Color.PICO_8_RED;
				case MOVE:Color.PICO_8_BLUE;
				case HEALTH:Color.PICO_8_GREEN;
				case SHIELD:Color.PICO_8_ORANGE;
			}
			var color_fill:Color = cast color.copy();
			color_fill.alpha = 0.2;
			for (tile in tiles) {
				var cont = false;
				for (prev_tile in placed_tiles) {
					if (cont) break;
					if (prev_tile.equals(tile)) cont = true;
				}
				if (cont) continue;
				placed_tiles.push(tile);
				indicators.fill_rect(color_fill, tile.x * 16 + 2, tile.y * 16 + 2, 12, 12, 2).rect(color, tile.x * 16 + 2, tile.y * 16 + 2, 12, 12, 2, 1);
			}
		}
	}

	function get_available_tiles_array(origin:IntPoint, min_range:Int, max_range:Int, restriction:RangeType = NONE):Array<IntPoint> {
		var solids = tiles.get_solids_array([for (i in 128...256) i]);
		var not_availables = tiles.get_solids_array();
		var map = solids.heat_map(origin.x, origin.y, max_range + 1);
		var out:Array<IntPoint> = [];
		for (j in 0...map.length) for (i in 0...map[j].length) if (map[j][i] > 0) {
			if (map[j][i] > max_range + 1 - min_range) map[j][i] = 0;
			else if (not_availables[j][i] != 0) map[j][i] = 0;
			else if (!AStar.los(origin, [i, j], solids, [0])) map[j][i] = 0;
			if (map[j][i] > 0) out.push([i, j]);
		}
		apply_restriction(origin, out, restriction);
		available_tiles = out;
		return out;
	}

	public function draw_move_indicators(movement:Movement) {
		move_indicators.graphics.clear();
		var object = movement.owner;
		var range = movement.get_moves_value();
		if (range == 0) return;
		var tiles = get_walkable_tiles_array([(object.x/16).floor(), (object.y/16).floor()], range);
		var color = Color.PICO_8_BLUE;
		var color_fill:Color = cast color.copy();
		color_fill.alpha = 0.2;
		for (tile in tiles) move_indicators.fill_rect(color_fill, tile.x * 16 + 2, tile.y * 16 + 2, 12, 12, 2).rect(color, tile.x * 16 + 2, tile.y * 16 + 2, 12, 12, 2, 1);
	}

	function get_walkable_tiles_array(origin:IntPoint, range:Int, restriction:RangeType = NONE):Array<IntPoint> {
		var solids = get_traversal_map(origin);
		var map = solids.heat_map(origin.x, origin.y, range + 1);
		var out:Array<IntPoint> = [];
		for (j in 0...map.length) for (i in 0...map[j].length) if (map[j][i] > 0 && map[j][i] <= range) out.push([i, j]);
		apply_restriction(origin, out, restriction);
		return out;
	}

	function apply_restriction(origin:IntPoint, arr:Array<IntPoint>, restriction:RangeType):Array<IntPoint> {
		switch restriction {
			case NONE: return arr;
			case ORTHOGONAL: 
				var remove = [];
				for (p in arr) if (p.x != origin.x && p.y != origin.y) remove.push(p);
				for (p in remove) arr.remove(p);
			case DIAGONAL:
				var remove = [];
				for (p in arr) if ((p.x - origin.x).abs() != (p.y - origin.y).abs()) remove.push(p);
				for (p in remove) arr.remove(p);
		}
		return arr;
	}

}