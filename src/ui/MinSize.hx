package ui;

import util.Translation;
import zero.openfl.utilities.Game;
import zero.utilities.Color;
import openfl.display.Sprite;
import openfl.text.TextField;

class MinSize extends Sprite {

	var bg:Sprite;
	var text:TextField;
	var icon:Sprite;

	public function new() {
		super();

		bg = new Sprite();
		bg.fill_rect(Color.PICO_8_LIGHT_GREY, -0.5, -0.5, 1, 1);
		
		text = new TextField().format({
			font: Translation.get_font(BOLD),
			size: 24,
			color: Color.BLACK,
			align: 'center'
		});
		
		icon = new Sprite().load_graphic('images/ui/error.png', BOTTOM_CENTER);
		
		addChild(bg);
		addChild(icon);
		addChild(text);

		resize.listen('resize');
	}

	function resize(?_) {
		var pass = Game.width >= 1024 && Game.width > Game.height;
		visible = !pass;
		if (pass) return;
		this.set_position(Game.width/2, Game.height/2);
		bg.set_scale(Game.width, Game.height);
		text.set_string(Translation.get_ui_text('min_size').wrap_string(text, Math.min(480, Game.width - 64))).set_position(0, 0, MIDDLE_CENTER);
		icon.y = text.y - text.height/4;
	}

}