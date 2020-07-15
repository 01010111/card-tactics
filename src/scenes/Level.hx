package scenes;

import ui.GearSprite;
import objects.GameObject;
import openfl.events.Event;
import util.PlayerData;
import ui.InventorySprite;
import data.Gear;
import data.Movement;
import data.Equipment;
import zero.openfl.utilities.Keys;
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
import particles.Pop;
import ui.InfoLayer;
import objects.Player;

using zero.utilities.AStar;
using zero.utilities.OgmoUtils;

class Level extends Scene {

	public static var i:Level;

	var tiles:Tilemap;
	public var object_map:Array<Array<Int>> = [];
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
	public var pops:Particles = new Particles(() -> new Pop());

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
		var player = new Player(2, 9, { data: PlayerData.player1, side: LEFT });
		var player2 = new Player(6, 8, { data: PlayerData.player2, side: RIGHT });
		Player.selected_player = player;
		player2.shield = 4;
		var box = new objects.Box(8, 8);
		dolly.flash(Color.BLACK, 1);

		addEventListener(Event.ENTER_FRAME, (e) -> if (Keys.just_pressed(82)) Game.i.change_scene(new Level()));
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
		if (GAMESTATE == ENEMY_TURN) return;
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
		if (GAMESTATE != USING_GEAR || e.localX < 0 || e.localY < 0) return;
		var x = (e.localX/16).floor();
		var y = (e.localY/16).floor();
		Player.selected_player.move_to(x, y);
		GAMESTATE = WAITING;
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
		if (GAMESTATE == PLACING_GEAR && GearSprite.PLACEABLE_GEAR != null) draw_indicators(GearSprite.PLACEABLE_GEAR.equipment, Player.selected_player);
		if (GAMESTATE != USING_GEAR) return;
		move_indicators.visible = true;
	}

	public function draw_indicators(?equipment:Equipment, ?equipment_array:Array<Equipment>, ?owner:GameObject) {
		var equips = equipment_array == null ? equipment == null ? [] : [equipment] : equipment_array;
		indicators.graphics.clear();
		move_indicators.visible = false;
		var placed_tiles:Array<IntPoint> = [];
		for (eq in equips) {
			var object = owner == null ? eq.inventory.owner : owner;
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
				case DRAW:Color.PICO_8_GREEN;
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