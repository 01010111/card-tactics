package objects;

import zero.openfl.utilities.AnimatedSprite;
import openfl.events.Event;
import zero.utilities.Vec2;
import zero.utilities.IntPoint;
import zero.utilities.Tween;
import scenes.Level;
import openfl.events.MouseEvent;
import openfl.display.Sprite;

using zero.openfl.extensions.SpriteTools;
using zero.extensions.Tools;
using Math;

class GameObject extends Sprite {

	public var health:HealthData;
	public var title:String;
	public var grid_pos(get, never):IntPoint;
	function get_grid_pos():IntPoint return [(x/16).floor(), (y/16).floor()];

	var last:Vec2;
	var graphic:AnimatedSprite;

	public function new(x:Int, y:Int, health:Int, title:String) {
		this.health = {
			current: health,
			max: health,
		};
		this.title = title;
		super();

		last = [x * 16 + 8, y * 16 + 8];
		this.set_position(last.x, last.y);

		addEventListener(MouseEvent.MOUSE_OVER, (e) -> Level.i.info_layer.show_info(this));
		addEventListener(MouseEvent.MOUSE_OUT, (e) -> Level.i.info_layer.hide_info());
		addEventListener(Event.ENTER_FRAME, (e) -> update(1/60));
	}

	function update(dt:Float) {
		var rot = last.x == x ? 0 : (last.x - x).sign_of() * 15;
		rotation += (rot - rotation) * 0.25;
		if (rot.abs() > 0) graphic.scaleX = -rot.sign_of();
		last.x = x;
	}


	public function follow_path(path:Array<IntPoint>) {
		var t = path.shift();
		Tween.get(this).from_to('x', x, t.x * 16 + 8).from_to('y', y, t.y * 16 + 8).duration(0.05).on_complete(() -> {
			if (path.length > 0) {
				follow_path(path);
				Level.i.poofs.fire({ x: t.x * 16 + 8, y: t.y * 16 + 8 });
			}
			else {
				pulse();
				Level.i.can_move = true;
			}
		});
		return true;
	}

	public function change_health(delta:Float) {
		health.current += delta;
		if (health.current <= 0) kill();
		health.current = health.current.min(health.max).max(0);
	}

	function kill() {
		
	}

	public function pulse() {
		Tween.get(this).from_to('scaleX', 1.5, 1).from_to('scaleY', 0.5, 1).ease(zero.utilities.Ease.elasticOut).duration(0.5);
	}

}

typedef HealthData = {
	current:Float,
	max:Float,
}