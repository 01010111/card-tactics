package;

import zero.utilities.Timer;
import scenes.Play;
import openfl.Lib;
import openfl.events.Event;
import zero.utilities.Color;
import openfl.display.Sprite;

class Main extends Sprite
{

	public static var i:Main;

	public function new()
	{
		super();
		i = this;
		stage.addEventListener(Event.RESIZE, (e) -> 'resize'.dispatch({ width: Lib.application.window.width, height: Lib.application.window.height }));
		stage.addEventListener(Event.ENTER_FRAME, util.UpdateManager.update);
		((?_) -> {
			Tween.update(_);
			Timer.update(_);
		}).listen('update');
		new Game(Play);
		addChild(new util.FPS(10, 10, 0xFFFFFF));
	}

}
