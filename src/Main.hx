package;

import util.GearUtil;
import util.UpdateManager;
import openfl.events.Event;
import zero.openfl.utilities.Game;
import openfl.display.Sprite;
import scenes.*;

class Main extends Sprite
{
	public function new()
	{
		super();
		stage.color = 0x000000;
		GearUtil.init();
		new Game(this, Level);
		stage.addEventListener(Event.ENTER_FRAME, UpdateManager.update);
	}
}
