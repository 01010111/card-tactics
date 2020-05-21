package util;

using hxmath.math.Vector2;

class EchoUtils {

	public static function square_normal(normal:Vector2) {
		var len = normal.length;
		var dot_x = normal.dot(Vector2.xAxis);
		var dot_y = normal.dot(Vector2.yAxis);
		if (dot_x.abs() > dot_y.abs()) dot_x > 0 ? normal.set(1, 0) : normal.set(-1, 0);
		else dot_y > 0 ? normal.set(0, 1) : normal.set(0, -1);
		normal.normalizeTo(len);
	}

	public static function eight_way_normal(normal:Vector2) {
		var vec = Vec2.get(normal.x, normal.y);
		vec.angle = vec.angle.snap_to_grid(45);
		normal.set(vec.x, vec.y);
		vec.put();
	}

}