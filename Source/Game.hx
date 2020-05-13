import scenes.Scene;
import openfl.Lib;

class Game {

	var scene:Scene;

	public static var width(get, never):Float;
	static function get_width() return Lib.application.window.width;

	public static var height(get, never):Float;
	static function get_height() return Lib.application.window.height;

	public function new(scene:Class<Scene>) {
		change_scene(Type.createInstance(scene, []));
	}

	public function change_scene(scene:Scene) {
		if (this.scene != null) this.scene.remove();
		this.scene = scene;
		Main.i.add(scene);
	}
	
}