package objects;

import zero.utilities.Tween;
import openfl.filters.ShaderFilter;
import zero.utilities.Color;
import filters.ColorShader;
import zero.utilities.Vec2;
import zero.openfl.utilities.Keys;
import openfl.display.DisplayObject;
import zero.openfl.utilities.Tilemap;
import zero.openfl.utilities.Game;
import zero.openfl.utilities.Dolly as ZDolly;

class Dolly extends ZDolly {

	public var following = true;
	var spring_offset:Vec2 = [0, 0];
	var spring_helper:Vec2 = [0, 0];
	var color_shader:ColorShader = new ColorShader(Color.WHITE);
	var color_mix:Float = 0;
	var overlay:Color = Color.WHITE;

	public function new() {
		super();
		filters = [new ShaderFilter(color_shader)];
	}

	public function follow_object(target:DisplayObject, snap:Bool = true, ?tilemap:Tilemap) {
		following = true;
		follow(target, snap, tilemap);
	}

	override public function update(?dt:Float) {
		x += spring_offset.x;
		y += spring_offset.y;
		spring_helper.x += ((0 - spring_offset.x) * 0.5 - spring_helper.x) * 0.3.get_random(0.1);
		spring_helper.y += ((0 - spring_offset.y) * 0.5 - spring_helper.y) * 0.3.get_random(0.1);
		spring_offset = spring_offset + spring_helper;
		if (check_keys()) return;
		if (target == null || !following) return;
		var zoomX = scaleX;
		var zoomY = scaleY;
		var p = parent;
		while (p != null) {
			zoomX *= p.scaleX;
			zoomY *= p.scaleY;
			p = p.parent;
		}
		position.set(-target.x * zoomX + Game.width/2, -target.y * zoomY + Game.height/2);
		x += (position.x + offset.x - x) * 0.1;
		y += (position.y + offset.y - y) * 0.1;
		color_shader.set_color(overlay);
		color_shader.set_mix(color_mix.normalize(2));
		trace(color_mix.normalize(2));
		invalidate();
	}

	var delta = 0.0;

	function check_keys() { // 87 83 65 68
		var dx = 0;
		var dy = 0;
		if (Keys.pressed(87)) dy += 1;
		if (Keys.pressed(83)) dy -= 1;
		if (Keys.pressed(65)) dx += 1;
		if (Keys.pressed(68)) dx -= 1;
		x += dx * delta;
		y += dy * delta;
		var out = dx != 0 || dy != 0;
		if (!out) delta = 0;
		else {
			delta += (16 - delta) * 0.1;
			following = false;
		}
		return out;
	}

	public function shake(amt:Float = 5) {
		var p = Vec2.get(0, amt);
		p.angle = 360 * Math.random();
		spring_offset += p;
		p.put();
	}

	public function flash(color:Color, duration:Float = 0.25, from:Float = 1, to:Float = 0) {
		overlay = color;
		Tween.get(this).from_to('color_mix', from, to).duration(duration);
	}

}