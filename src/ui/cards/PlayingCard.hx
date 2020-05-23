package ui.cards;

import openfl.geom.Point;
import zero.utilities.Tween;
import zero.utilities.Vec2;
import zero.utilities.Color;
import openfl.text.TextField;
import openfl.display.Sprite;
import openfl.events.MouseEvent;

using zero.openfl.extensions.SpriteTools;
using zero.openfl.extensions.TextTools;
using zero.extensions.Tools;
using zero.utilities.EventBus;

class PlayingCard extends Card {

	static var card_width:Float = 128;
	static var card_height:Float = 192;
	static var mini_width:Float = 64;
	static var mini_height:Float = 80;
	
	public var gear:GearCard;
	var deck:Deck;
	var data:PlayingCardData;
	var last:Vec2;
	var face:Sprite;
	var mini_face:Sprite;
	var equipped:Bool = false;

	public function new(deck:Deck, card_data:PlayingCardData, x:Float, y:Float) {
		super();
		this.deck = deck;
		this.data = card_data;
		this.x = x;
		this.y = y;
		last = [x, y];
		update.listen('update');
		draw_face();
	}

	function draw_face() {
		var val = switch data.value {
			case ACE:'A';
			case TWO:'2';
			case THREE:'3';
			case FOUR:'4';
			case FIVE:'5';
			case SIX:'6';
			case SEVEN:'7';
			case EIGHT:'8';
			case NINE:'9';
			case TEN:'10';
			case JACK:'J';
			case QUEEN:'Q';
			case KING:'K';
		}
		
		var src = switch data.suit {
			case HEARTS:'images/ui/suit_heart.png';
			case DIAMONDS:'images/ui/suit_diamond.png';
			case CLUBS:'images/ui/suit_club.png';
			case SPADES:'images/ui/suit_spade.png';
		}
		
		face = new Sprite();
		face.fill_rect(Color.PICO_8_WHITE, -card_width/2, -card_height/2, card_width, card_height, 8);
		face.rect(Color.BLACK, -card_width/2, -card_height/2, card_width, card_height, 7, 4);

		var text = new TextField()
			.format({ font: 'Oduda Bold', size: 24, color: Color.BLACK })
			.set_string(val)
			.set_position(-40, -72, MIDDLE_CENTER);

		var sprite = new Sprite().load_graphic(src, MIDDLE_CENTER);
		sprite.set_scale(96/256);
		
		face.add(text);
		face.add(sprite);

		mini_face = new Sprite();
		mini_face.fill_rect(Color.PICO_8_WHITE, -mini_width/2, -mini_height/2, mini_width, mini_height, 8);
		mini_face.rect(Color.BLACK, -mini_width/2, -mini_height/2, mini_width, mini_height, 7, 4);
		mini_face.set_scale(card_width/mini_width, card_height/mini_height);

		var text = new TextField()
			.format({ font: 'Oduda Bold', size: 24, color: Color.BLACK })
			.set_string(val)
			.set_position(0, -24, MIDDLE_CENTER);

		var sprite = new Sprite().load_graphic(src, MIDDLE_CENTER).set_position(0, 12);
		sprite.set_scale(56/256);

		mini_face.add(text);
		mini_face.add(sprite);

		this.add(face);
		this.add(mini_face);

		mini_face.alpha = 0;
	}

	override function mouse_down(e:MouseEvent) {
		if (equipped) {
			var p = localToGlobal(new Point(x, y));
			gear.remove_card(this);
			deck.add_card(this);
			x = p.x;
			y = p.y;
			equipped = false;
			draggable = true;
		}
		if (!draggable) return;
		super.mouse_down(e);
		deck.remove_from_hand(this);
		var p = parent;
		p.removeChild(this);
		p.addChild(this);
	}

	override function mouse_up(e:MouseEvent) {
		if (!dragging) return;
		if (!equipped) for (card in Gear.active_gear.gear_cards) {
			var pos = card.get_anchor(true);
			if (pos.distance([x, y]) < 128) {
				card.add_card(this);
				equipped = true;
				super.mouse_up(e);
				pos.put();
				draggable = false;
				return;
			}
			pos.put();
		}
		super.mouse_up(e);
		deck.add_to_hand(this);
	}
	
	function update(?dt) {
		rotation += ((x - last.x)/2 - rotation) * 0.1;
		last.set(x, y);
		lerp_size();
	}
	
	function lerp_size() {
		var sxt = equipped ? mini_width/card_width : 1;
		var syt = equipped ? mini_height/card_height : 1;
		scaleX += (sxt - scaleX) * 0.25;
		scaleY += (syt - scaleY) * 0.25;
		mini_face.alpha += ((equipped ? 1 : 0) - mini_face.alpha) * 0.25;
		face.alpha += ((equipped ? 0 : 1) - face.alpha) * 0.25;		
	}

}

typedef PlayingCardData = {
	value: PlayingCardValue,
	suit: PlayingCardSuit,
}

enum PlayingCardValue {
	ACE;
	TWO;
	THREE;
	FOUR;
	FIVE;
	SIX;
	SEVEN;
	EIGHT;
	NINE;
	TEN;
	JACK;
	QUEEN;
	KING;
}

enum PlayingCardSuit {
	HEARTS;
	DIAMONDS;
	CLUBS;
	SPADES;
}