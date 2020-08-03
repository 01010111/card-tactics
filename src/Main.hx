package;

import zero.openfl.utilities.Keys;
import util.EquipmentUtil;
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
		EquipmentUtil.init();
		Translation.init();
		new Game(this, Level);
		addChild(new ui.MinSize());
		Keys.init();
		stage.addEventListener(Event.ENTER_FRAME, UpdateManager.update);
		stage.addEventListener(Event.RESIZE, (e) -> 'resize'.dispatch(e));
		addChild(new ui.InfoBox().set_position(32, Game.height - 56));
	}
}
