package objects;

import zero.utilities.IntPoint;
import scenes.Level;
import zero.utilities.Tween;
import openfl.events.Event;
import zero.openfl.utilities.AnimatedSprite;

using zero.extensions.Tools;
using zero.openfl.extensions.SpriteTools;
using Math;

class Player extends GameObject {

	var last_x:Float;
	var last_y:Float;
	var graphic:AnimatedSprite;

	public function new(x:Float, y:Float) {
		super(64, 'Test Player');
		
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
		graphic.set_frame_index(8.get_random().floor());
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

	public function follow_path(path:Array<IntPoint>) {
		var t = path.shift();
		var tween = Tween.get(this).from_to('x', x, t.x * 16 + 8).from_to('y', y, t.y * 16 + 8).duration(0.05).on_complete(() -> {
			if (path.length > 0) {
				follow_path(path);
				Level.i.poofs.fire({ x: t.x * 16 + 8, y: t.y * 16 + 8 });
			}
			else {
				pulse();
				Level.i.can_move = true;
			}
		});
		//tween.update_tween(1/60);
		return true;
	}


}