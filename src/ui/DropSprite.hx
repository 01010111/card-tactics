package ui;

import openfl.geom.Point;
import interfaces.Expendable;
import data.Equipment.Requirement;
import openfl.events.MouseEvent;
import zero.utilities.Ease;
import zero.utilities.Tween;
import openfl.display.Sprite;
import zero.utilities.Color;
import openfl.events.Event;
import zero.utilities.Vec2;
import ui.PlayingCard;

using util.CardUtil;

class DropSprite extends Card {

	public var active(default, set):Bool = false;
	public var expended(get, never):Bool;
	var anchor:Vec2;
	var anchors:Array<Vec2>;
	var cards:Array<PlayingCard> = [];
	var data:DropSpriteData;
	var active_highlight:Sprite;
	var execute_highlight:Sprite;
	var last:Vec2;
	var expendable:Expendable;

	public function new() {
		super();
		last = [x, y];
		anchor = [0, 0];
		addEventListener(Event.ENTER_FRAME, update);
	}

	override function mouse_down(e:MouseEvent) {
		super.mouse_down(e);
		var p = parent;
		this.remove();
		p.addChild(this);
	}

	public function verify_card(card_data:PlayingCardData):Bool {
		if (cards.length >= 2) return false;
		switch data.requirement {
			default: return false;
			case MIN_TOTAL:
				var total = 0;
				for (card in cards) total += card.data.value.value_to_int();
				return total + card_data.value.value_to_int() >= data.requirement_value || cards.length == 0;
			case MAX_TOTAL:
				var total = 0;
				for (card in cards) total += card.data.value.value_to_int();
				return total + card_data.value.value_to_int() <= data.requirement_value;
			case MIN_CARD:
				return card_data.value.value_to_int() >= data.requirement_value;
			case MAX_CARD:
				return card_data.value.value_to_int() <= data.requirement_value;
			case EXACT_CARD:
				return card_data.value.value_to_int() == data.requirement_value;
			case EXACT_TOTAL:
				var total = 0;
				for (card in cards) total += card.data.value.value_to_int();
				return total + card_data.value.value_to_int() == data.requirement_value || cards.length == 0;
			case IS_FACE:
				return [JACK, QUEEN, KING].contains(card_data.value);
			case NOT_FACE:
				return ![JACK, QUEEN, KING].contains(card_data.value);
			case PAIR: 
				return cards.length == 0 || cards[0].data.value == card_data.value;
			case NO_MATCH:
				return cards.length == 0 || cards[0].data.value != card_data.value;
			case SAME_SUIT:
				return cards.length == 0 || cards[0].data.suit == card_data.suit;
			case DIFF_SUIT:
				return cards.length == 0 || cards[0].data.suit != card_data.suit;
			case HEARTS:
				return card_data.suit == HEARTS;
			case DIAMONDS:
				return card_data.suit == DIAMONDS;
			case CLUBS:
				return card_data.suit == CLUBS;
			case SPADES:
				return card_data.suit == CLUBS;
			case TWO_CARDS:
				return true;
		}
	}

	public function get_anchor(global:Bool = false):Vec2 {
		if (global) {
			var p = localToGlobal(new Point(anchor.x, anchor.y));
			return [p.x, p.y];
		}
		else return anchor;
	}

	public function add_card(card:PlayingCard) {
		this.add(card);
		cards.push(card);
		card.drop = this;
		var p = globalToLocal(new Point(card.x, card.y));
		card.x = p.x;
		card.y = p.y;
	}

	public function remove_card(card:PlayingCard) {
		cards.remove(card);
	}

	var t = 0.0;
	function update(e:Event) {
		var i = 0;
		for (card in cards) {
			if (card.dragging) continue;
			card.x += (anchors[i].x - card.x) * 0.25;
			card.y += (anchors[i].y - card.y) * 0.25;
			i++;
		}
		if (dragging) rotation += ((x - last.x) - rotation) * 0.1;
		last.set(x, y);
		var rot_target = active ? (t += 0.15).sin() * 4 : 0;
		rotation += (rot_target - rotation) * 0.25;
		invalidate(); // TODO - this is a hack that forces a redraw, fixes expended cards disappearing until onclick event
	}

	function make_highlights() {
		addChild(active_highlight = new Sprite().rect(Color.PICO_8_WHITE, -EquipmentSprite.WIDTH/2 + 4, -EquipmentSprite.HEIGHT/2 + 4, EquipmentSprite.WIDTH - 8, EquipmentSprite.HEIGHT - 8, 16, 8));
		Tween.get(active_highlight).from_to('scaleX', 1, 1.1).from_to('scaleY', 1, 1.1).from_to('alpha', 1, 0).type(LOOP_FORWARDS).duration(1).ease(Ease.quadOut);
		active_highlight.visible = false;

		addChild(execute_highlight = new Sprite().rect(Color.PICO_8_WHITE, -EquipmentSprite.WIDTH/2 + 4, -EquipmentSprite.HEIGHT/2 + 4, EquipmentSprite.WIDTH - 8, EquipmentSprite.HEIGHT - 8, 16, 8));
		execute_highlight.alpha = 0;
	}

	function set_active(b:Bool) {
		active_highlight.visible = b;
		return active = b && !expended;
	}

	function get_expended() {
		return expendable.expended;
	}

	public function execute() {
		Tween.get(execute_highlight).from_to('alpha', 1, 0).from_to('scaleX', 1, 1.1).from_to('scaleY', 1, 1.1).duration(0.5).ease(Ease.quadOut);
		Tween.get(this).from_to('scaleX', 1.1, 1).from_to('scaleY', 1.1, 1).duration(0.5).ease(Ease.quadOut);
	}

}

typedef DropSpriteData = {
	requirement:Requirement,
	?requirement_value:Int,
}