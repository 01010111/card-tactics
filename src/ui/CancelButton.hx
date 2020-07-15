package ui;

import zero.utilities.Ease;
import zero.openfl.utilities.Game;
import zero.utilities.Color;
import util.Translation;
import openfl.text.TextField;
import zero.utilities.Tween;
import openfl.events.MouseEvent;
import openfl.display.Sprite;

class CancelButton extends Sprite {

	var on_click:Void -> Void;
	var dismiss_event:EventType;

	public function new(text:String, on_click:Void -> Void, dismiss_event:EventType) {
		super();
		this.on_click = on_click;
		addEventListener(MouseEvent.CLICK, mouse_down);
		var cancel_text = new TextField().format({ font: Translation.get_font(BOLD), size: 14, color: Color.WHITE }).set_string(text).set_position(0, 0, MIDDLE_CENTER);
		var width = cancel_text.width + 64;
		this.fill_rect(Color.PICO_8_RED, -width/2, -24, width, 48, 48).rect(Color.BLACK, -width/2, -24, width, 48, 48, 4);
		this.add(cancel_text);
		this.set_position(Game.width - 32 - EquipmentSprite.WIDTH/2, Game.height - 48).set_scale(0);
		((?_) -> if (_.type == dismiss_event) dismiss()).listen('game_event');
		Tween.get(this).from_to('scaleX', 0, 1).from_to('scaleY', 0, 1).ease(Ease.elasticOut).duration(1);
	}

	function mouse_down(e:MouseEvent) {
		on_click();
		dismiss();
	}

	function dismiss() {
		removeEventListener(MouseEvent.CLICK, mouse_down);
		Tween.get(this).from_to('scaleX', 1, 0).from_to('scaleY', 1, 0).on_complete(() -> this.remove()).ease(Ease.backIn).duration(0.2);
	}

}