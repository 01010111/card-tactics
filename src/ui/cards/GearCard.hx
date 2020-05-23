package ui.cards;

import zero.utilities.Color;
import openfl.events.Event;
import zero.utilities.Vec2;
using zero.openfl.extensions.SpriteTools;

class GearCard extends Card {
	
	var card_width:Float = 192;
	var card_height:Float = 224;
	var last:Vec2;
	var home:Vec2;
	var gear:Gear;
	var anchor:Vec2;
	var cards:Array<PlayingCard> = [];
	
	public function new(x:Float, y:Float, gear:Gear) {
		super();
		this.gear = gear;
		this.set_position(x, y);
		draggable = false;
		this.fill_rect(Color.PICO_8_GREEN, -card_width/2, -card_height/2, card_width, card_height, 16);
		addEventListener(Event.ENTER_FRAME, update);
		last = [x, y];
		home = [x, y];
		anchor = [0, 0];
	}
	
	function update(e:Event) {
		rotation += ((x - last.x)/2 - rotation) * 0.25;
		last.set(x, y);
		for (card in cards) {
			if (card.dragging) continue;
			card.x += (anchor.x - card.x) * 0.2;
			card.y += (anchor.y - card.y) * 0.2;
		}
		if (!dragging && home.length > 0) {
			x += (home.x - x) * 0.1;
			y += (home.y - y) * 0.1;
		}
	}

	public function get_anchor(global:Bool = false):Vec2 {
		return global ? [anchor.x + x, anchor.y + y] : anchor;
	}

	public function add_card(card:PlayingCard) {
		this.add(card);
		cards.push(card);
		card.x -= x;
		card.y -= y;
		card.gear = this;
	}

	public function remove_card(card:PlayingCard) {
		cards.remove(card);
	}

}