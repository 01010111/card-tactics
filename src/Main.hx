package;

import zero.openfl.utilities.Keys;
import util.GearUtil;
import util.UpdateManager;
import util.Translation;
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
		Translation.init();
		Translation.get_gear_title('test_d_01');
		new Game(this, Level);
		Keys.init();
		stage.addEventListener(Event.ENTER_FRAME, UpdateManager.update);
	}
}
