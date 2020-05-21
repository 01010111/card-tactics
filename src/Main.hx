package;

import zero.openfl.utilities.Game;
import openfl.display.Sprite;
import scenes.Level;

using zero.openfl.extensions.SpriteTools;

class Main extends Sprite
{
	public function new()
	{
		super();
		stage.color = 0x000000;
		new Game(this, Level);
	}
}
