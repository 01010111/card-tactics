package ui;

import zero.utilities.Color;
import util.Translation;
import openfl.text.TextField;
import openfl.display.Sprite;

class InfoBox extends Sprite {
	
	var text:TextField;
	var bg:Sprite;

	public function new() {
		super();
		make_graphics();
		show_info.listen('tooltip');
	}

	function make_graphics() {
		bg = new Sprite();
		text = new TextField().format({ font: Translation.get_font(BOLD), size: 16, color: Color.WHITE });
		addChild(bg);
		addChild(text);
	}

	function show_info(?options:InfoOptions) {
		if (options.info == null) {
			visible = false;
			return;
		} 
		visible = true;
		bg.graphics.clear();
		text.set_string(options.info).set_position(16, 0, MIDDLE_LEFT);
		bg.fill_rect(Color.PICO_8_DARK_BLUE, 0, -24, text.width + 32, 48, 4);
	}

}

typedef InfoOptions = {
	?info:String,
}