package objects;

import zero.utilities.Color;
import zero.openfl.utilities.AnimatedSprite;
import openfl.events.Event;
import zero.utilities.Vec2;
import zero.utilities.IntPoint;
import zero.utilities.Tween;
import scenes.Level;
import openfl.events.MouseEvent;
import openfl.display.Sprite;
import data.Inventory;

using zero.utilities.AStar;

class GameObject extends Sprite {

	public var health:HealthData;
	public var shield(default, set):Int = 0;
	public var title:String;
	public var inventory:Inventory;
	public var grid_pos(get, never):IntPoint;
	public var exists:Bool;
	public var AP(default, set):Int = 0;

	function get_grid_pos():IntPoint return [(x/16).floor(), (y/16).floor()];

	var last:Vec2;
	var graphic:AnimatedSprite;

	public function new(x:Int, y:Int, health:HealthData, title:String) {
		exists = true;
		this.health = health;
		this.title = title;
		inventory = new Inventory(this);
		super();

		update_object_map(x, y);
		last = [x * 16 + 8, y * 16 + 8];
		this.set_position(last.x, last.y);

		addEventListener(MouseEvent.MOUSE_OVER, mouse_over);
		addEventListener(MouseEvent.MOUSE_OUT, mouse_out);
		addEventListener(Event.ENTER_FRAME, (e) -> update(1/60));
	}

	function mouse_over(e:MouseEvent) {
		if (GAMESTATE != USING_GEAR) return;
		LEVEL.info_layer.show_info(this);
	}

	function mouse_out(e:MouseEvent) {
		LEVEL.info_layer.hide_info();
	}

	function update(dt:Float) {
		var rot = last.x == x ? 0 : (last.x - x).sign_of() * 15;
		rotation += (rot - rotation) * 0.25;
		if (rot.abs() > 0) graphic.scaleX = -rot.sign_of();
		last.x = x;
	}

	public function move_to(x:Int, y:Int) {
		var map = LEVEL.get_traversal_map();
		if (map[y][x] != 0) return;
		var sx = (this.x/16).floor();
		var sy = (this.y/16).floor();
		var path = map.get_path({ start: [sx, sy], end: [x, y], passable: [0], simplify: NONE });
		if (path.length == 0) return;
		update_object_map(sx, sy, x, y);
		follow_path(path);
		LEVEL.sort_objects();
	}

	function update_object_map(sx:Int, sy:Int, ?x:Int, ?y:Int) {
		if (x == null) x = sx;
		if (y == null) y = sy;
		if (sx >= 0 && sy >= 0) LEVEL.object_map[sy][sx] = 0;
		if (x >= 0 && y >= 0) LEVEL.object_map[y][x] = -1;
	}

	public function follow_path(path:Array<IntPoint>) {
		var t = path.shift();
		Tween.get(this).from_to('x', x, t.x * 16 + 8).from_to('y', y, t.y * 16 + 8).duration(0.05).on_complete(() -> {
			if (path.length > 0) {
				follow_path(path);
				LEVEL.poofs.fire({ x: t.x * 16 + 8, y: t.y * 16 + 8 });
			}
			else {
				pulse();
				if (GAMESTATE == WAITING) GAMESTATE = USING_GEAR;
			}
		});
		return true;
	}

	public function change_health(delta:Int) {
		if (delta < 0) LEVEL.dolly.shake();
		if (delta < 0 && shield != 0) {
			var shield_amt = shield;
			shield = (shield + delta).max(0).floor();
			delta += shield_amt;
		}
		health.current += delta;
		if (health.current <= 0) kill();
		health.current = health.current.min(health.max).max(0).floor();
		health_callback();
	}

	function health_callback() {}

	function kill() {
		exists = false;
		this.remove();
		update_object_map(grid_pos.x, grid_pos.y, -1, -1);
		drop(grid_pos.x, grid_pos.y);
		LEVEL.info_layer.hide_info();
		LEVEL.pops.fire({ x: x, y: y });
		LEVEL.dolly.flash(Color.WHITE, 0.25, 0.25);
	}

	public function pulse() {
		Tween.get(this).from_to('scaleX', 1.5, 1).from_to('scaleY', 0.5, 1).ease(zero.utilities.Ease.elasticOut).duration(0.5);
	}

	function set_shield(amt:Int) {
		shield = amt;
		'game_event'.dispatch({ type:SHIELD, data: { object:this, value:amt }});
		return shield;
	}

	function set_AP(v:Int) {
		return AP = v;
	}

	public function drop(x:Int, y:Int) {
		trace('drop', x, y);
	}

}

typedef HealthData = {
	current:Int,
	max:Int,
}