package scenes;

import zero.openfl.utilities.Game;
import zero.openfl.utilities.Scene;
import zero.utilities.Color;
import zero.utilities.Anchor;
import openfl.text.TextField;
import zero.utilities.Timer;

class TextTest extends Scene {

	override function create() {
		for (j in 0...2) for (i in 0...2) this.rect(Color.get(1,1,1), Game.width/2 * i, Game.height/2 * j, Game.width/2, Game.height/2);
		var x = 0;
		var y = 0;
		TextTools.store_format('test', { font: 'Oduda Bold', size: 32, color: Color.WHITE });
		for (pos in Anchor.all()) {
			var text = new TextField()
				.from_format('test', { color: [Color.PICO_8_YELLOW, Color.PICO_8_RED, Color.PICO_8_GREEN][x % 3] })
				.set_string('$pos')
				.set_autosize(LEFT)
				.set_position(x++ % 3 * Game.width/2, (y++ / 3).floor() * Game.height/2, pos);
			this.rect(Color.PICO_8_YELLOW, text.x, text.y, text.width, text.height);
			addChild(text);
		}
		var text = new TextField().from_format('test');
		text.set_position(32, 64);
		var string = 'Hello! This is a test to see if wrapping works or not :) I dunno if it will work but I sure hope it does!'.wrap_string(text, Game.width/2 - 64);
		for (i in 0...string.length + 1) Timer.get(0.05 * i + 2, () -> text.text = string.substr(0,i + 1));
		addChild(text);
	}

}