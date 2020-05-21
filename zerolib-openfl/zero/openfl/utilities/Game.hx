package zero.openfl.utilities;

import openfl.display.Sprite;
import zero.openfl.utilities.Scene;
import zero.openfl.utilities.FPS;
import openfl.Lib;

using zero.openfl.extensions.SpriteTools;

class Game {

	public static var i:Game;

	public static var width(get, never):Float;
	static function get_width() return Lib.application.window.width;

	public static var height(get, never):Float;
	static function get_height() return Lib.application.window.height;

	public var scene(default, null):Scene;
	#if echo
	public var world(default, null):World;
	#end

	public static var root:Sprite;

	public function new(root:Sprite, scene:Class<Scene>) {
		i = this;
		Game.root = root;

		#if echo
		world = new World({
			width: Game.width,
			height: Game.height
		});

		var update = (?dt) -> world.step(dt);
		update.listen('update');
		#end

		change_scene(Type.createInstance(scene, []));
	}

	public function change_scene(scene:Scene) {
		if (this.scene != null) this.scene.remove();
		this.scene = scene;
		scene.create();
		root.add(scene);
		#if debug
		root.add(new FPS(10, 10, 0xFFFFFF));
		#end
	}
	
}