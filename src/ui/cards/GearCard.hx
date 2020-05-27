package ui.cards;

import openfl.events.MouseEvent;
import openfl.text.TextFormatAlign;
import zero.utilities.Ease;
import zero.utilities.Tween;
import openfl.text.TextField;
import openfl.display.Sprite;
import zero.utilities.Color;
import openfl.events.Event;
import zero.utilities.Vec2;
import ui.cards.PlayingCard;

using zero.openfl.extensions.SpriteTools;
using zero.openfl.extensions.TextTools;
using Std;
using Math;
using util.CardUtil;
using zero.extensions.Tools;

class GearCard extends Card {
	
	var card_width:Float = 192;
	var card_height:Float = 224;
	var last:Vec2;
	var home:Vec2;
	var gear:Gear;
	var anchor:Vec2;
	var anchors:Array<Vec2> = [[-35, 28], [35, 28]];
	var cards:Array<PlayingCard> = [];
	var description:TextField;
	var data:GearData;
	var req_text:TextField;
	var req_text_r:TextField;
	
	public function new(x:Float, y:Float, gear:Gear, data:GearData) {
		super();
		this.gear = gear;
		this.data = data;
		this.set_position(x, y);
		draggable = false;
		last = [x, y];
		home = [x, y];
		anchor = [0, 0];
		draw_card();
		addEventListener(Event.ENTER_FRAME, update);
	}
	
	function draw_card() {
		// Back
		{
			this.fill_rect(Color.get().from_int32(0xFF7CB11F), -card_width/2, -card_height/2, card_width, card_height, 16);
			this.rect(Color.BLACK, -card_width/2 + 2, -card_height/2 + 2, card_width - 4, card_height - 4, 12, 4);
		}
		
		// Contents
		{
			var contents = new Sprite();
			contents.set_position(-card_width/2, -card_height/2);
			this.add(contents);

			// AP cost
			{
				for (i in 0...data.cost) {
					var pip = new Sprite().load_graphic('images/ui/ap_pip.png', TOP_LEFT, true).set_position(165 - i * 11, 10);
					contents.add(pip);
				}
			}

			// Title
			{
				contents.add(new Sprite().fill_rect(Color.PICO_8_WHITE, 26, 28, 140, 24, 24));
				var title = new TextField().format({ font: 'Oduda Bold', size: 16, color: Color.BLACK }).set_string(data.title).set_position(40, 38, MIDDLE_LEFT);
				contents.add(title);
			}

			// Description
			{
				description = new TextField().format({ font: 'Oduda Bold', size: 14, color: Color.BLACK, leading: -2 });
				contents.add(description);
				set_description();
			}
		
			// Drop box
			{
				contents.add(new Sprite().fill_rect(Color.PICO_8_DARK_GREEN, 16, 92, 160, 96, 16));

				req_text = new TextField().format({ font: 'Oduda Bold', size: 20, color: Color.PICO_8_DARK_BLUE });
				contents.add(req_text);
				set_req_text();

				req_text_r = new TextField().format({ font: 'Oduda Bold', size: 16, color: Color.PICO_8_DARK_BLUE, align: TextFormatAlign.CENTER });
				contents.add(req_text_r);
				set_req_text_r();
			}

			// Bonus
			{
				var src = switch data.bonus.requirement {
					case IS_FACE:'images/ui/rule_face.png';
					case HEARTS:'images/ui/suit_heart.png';
					case DIAMONDS:'images/ui/suit_diamond.png';
					case CLUBS:'images/ui/suit_club.png';
					case SPADES:'images/ui/suit_spade.png';
					default: 'images/blank.png';
				}
				contents.add(new Sprite().load_graphic(src, MIDDLE_CENTER, true).set_position(20, 92).set_scale(0.125));
			}

			// Classes
			{
				var class_src = switch data.gear_class {
					case FLAME:'images/ui/icons/on_white/icon_flame.png';
					case PIERCING:'images/ui/icons/on_white/icon_pierce.png';
					case EXPLOSIVE:'images/ui/icons/on_white/icon_explode.png';
					case ELECTRICITY:'images/ui/icons/on_white/icon_electrify.png';
					case WATER:'images/ui/icons/on_white/icon_water.png';
					case SHIELD:'images/ui/icons/on_white/icon_shield.png';
					case MOVE:'images/ui/icons/on_white/icon_move.png';
					case HEALTH:'images/ui/icons/on_white/icon_health.png';
					case UTILITY:'images/ui/icons/on_white/icon_utility.png';
				}
				var weakness_src = switch data.weakness {
					case FLAME:'images/ui/icons/on_white/icon_flame.png';
					case PIERCING:'images/ui/icons/on_white/icon_pierce.png';
					case EXPLOSIVE:'images/ui/icons/on_white/icon_explode.png';
					case ELECTRICITY:'images/ui/icons/on_white/icon_electrify.png';
					case WATER:'images/ui/icons/on_white/icon_water.png';
					case SHIELD:'images/ui/icons/on_white/icon_shield.png';
					case MOVE:'images/ui/icons/on_white/icon_move.png';
					case HEALTH:'images/ui/icons/on_white/icon_health.png';
					case UTILITY:'images/ui/icons/on_white/icon_utility.png';
				}
				contents.addChild(new Sprite().load_graphic(class_src, TOP_LEFT, true).set_position(16, 196).set_scale(0.25));
				contents.addChild(new Sprite().load_graphic(weakness_src, TOP_LEFT, true).set_position(160, 196).set_scale(0.25));
				contents.addChild(new Sprite().load_graphic('images/ui/icons/icon_skull.png', TOP_LEFT, true).set_position(144, 180).set_scale(0.25));
			}
		}
	}

	function set_description() {
		var str = switch data.effect.type {
			case DAMAGE: 'Do ${get_effect_value()} damage';
			case MOVE: 'Move ${get_effect_value()} spaces';
			case SHIELD: 'Shield against ${get_effect_value()} damage';
		}
		description.set_string(str.wrap_string(description, 128)).set_position(card_width/2, 70, MIDDLE_CENTER);
	}

	function get_effect_value() {
		var out = 0;
		switch data.effect.factor {
			case VALUES:
				for (card in cards) out += card.data.value.value_to_int();
			case STATIC:
				out = data.effect.value;	
		}
		if (vefify_bonus()) {
			switch data.bonus.type {
				case DOUBLE_EFFECT_VALUE: out *= 2;
				case DOUBLE_RANGE: {}
			}
		}
		return out == 0 ? '_' : '$out';
	}

	function set_req_text() {
		if (cards.length > 0) {
			req_text.set_string('');
			return;
		}
		var str = switch data.requirement {
			case MIN_TOTAL: 'All > ${data.requirement_value - 1}';
			case MAX_TOTAL: 'All < ${data.requirement_value + 1}';
			case MIN_CARD: '> ${data.requirement_value - 1}';
			case MAX_CARD: '< ${data.requirement_value + 1}';
			case EXACT_CARD: '= ${data.requirement_value}';
			case EXACT_TOTAL: 'All = ${data.requirement_value}';
			case IS_FACE: 'Face';
			case NOT_FACE: 'Not Face';
			case PAIR: 'Pair';
			case NO_MATCH: 'Not Pair';
			case SAME_SUIT: 'Same Suit';
			case DIFF_SUIT: 'Different Suit';
			case HEARTS: 'Hearts';
			case DIAMONDS: 'Diamonds';
			case CLUBS: 'Clubs';
			case SPADES: 'Spades';
		}
		req_text.set_string(str).set_position(card_width/2, 140, MIDDLE_CENTER);
	}

	function set_req_text_r() {
		if (cards.length == 0 || cards.length == 2) {
			req_text_r.set_string('');
			return;
		}
		var str = switch data.requirement {
			case MIN_TOTAL: '> ${(data.requirement_value - 1 - cards[0].data.value.value_to_int()).max(0)}';
			case MAX_TOTAL: '< ${data.requirement_value + 1 - cards[0].data.value.value_to_int()}';
			case MIN_CARD: '> ${data.requirement_value - 1}';
			case MAX_CARD: '< ${data.requirement_value + 1}';
			case EXACT_CARD: '= ${data.requirement_value}';
			case EXACT_TOTAL: '= ${data.requirement_value - cards[0].data.value.value_to_int()}';
			case IS_FACE: 'Face';
			case NOT_FACE: 'Not\nFace';
			case PAIR: '= ${cards[0].data.value.value_to_string()}';
			case NO_MATCH: 'Not\n${cards[0].data.value.value_to_string()}';
			case SAME_SUIT: '${cards[0].data.suit.suit_to_string()}';
			case DIFF_SUIT: 'Not\n${cards[0].data.suit.suit_to_string()}';
			case HEARTS: 'Hearts';
			case DIAMONDS: 'Diamonds';
			case CLUBS: 'Clubs';
			case SPADES: 'Spades';
		}
		req_text_r.set_string(str).set_position(card_width/2 + 36, 140, MIDDLE_CENTER);
	}
	
	function update(e:Event) {
		rotation += ((x - last.x)/2 - rotation) * 0.25;
		last.set(x, y);
		var i = 0;
		for (card in cards) {
			if (card.dragging) continue;
			card.x += (anchors[i].x - card.x) * 0.25;
			card.y += (anchors[i].y - card.y) * 0.25;
			i++;
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
		set_description();
		set_req_text();
		set_req_text_r();
		//draggable = verify_gear();
	}

	public function remove_card(card:PlayingCard) {
		cards.remove(card);
		set_description();
		set_req_text();
		set_req_text_r();
		//draggable = verify_gear();
	}

	public function verify_card(card_data:PlayingCardData):Bool {
		if (cards.length >= 2) return false;
		switch data.requirement {
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
		}
	}

	public function verify_gear():Bool {
		if (cards.length == 0) return false;
		var total = 0;
		for (card in cards) total += card.data.value.value_to_int();
		return switch data.requirement {
			case MIN_TOTAL: total >= data.requirement_value;
			case MAX_TOTAL: total <= data.requirement_value;
			case EXACT_TOTAL: total == data.requirement_value;
			default: true;
		}
	}

	function vefify_bonus() {
		switch data.bonus.requirement {
			case IS_FACE: for (card in cards) if (![JACK, QUEEN, KING].contains(card.data.value)) return false;
			case HEARTS: for (card in cards) if (card.data.suit != HEARTS) return false;
			case DIAMONDS: for (card in cards) if (card.data.suit != DIAMONDS) return false;
			case CLUBS: for (card in cards) if (card.data.suit != CLUBS) return false;
			case SPADES: for (card in cards) if (card.data.suit != SPADES) return false;
			default: return false;
		}
		return true;
	}


}

typedef GearData = {
	title:String,
	description:String,
	cost:Int,
	range:RangeData,
	effect:EffectData,
	requirement:Requirement,
	gear_class:GearClass,
	weakness:GearClass,
	bonus:BonusData,
	?requirement_value:Int,
  }
  
  typedef RangeData = {
	min:Int,
	max:Int,
	type:RangeType,
  }
  
  typedef EffectData = {
	type:EffectType,
	factor:EffectFactor,
	?value:Int,
  }
  
  typedef BonusData = {
	requirement:Requirement,
	type:BonusType,
  }
  
  enum RangeType {
	NONE;
	ORTHOGONAL;
	DIAGONAL;
  }
  
  enum EffectType {
	DAMAGE;
	MOVE;
	SHIELD;
  }
  
  enum EffectFactor {
	VALUES;
	STATIC;
  }
  
  enum BonusType {
	DOUBLE_EFFECT_VALUE;
	DOUBLE_RANGE;
  }
  
  enum Requirement {
	MIN_TOTAL;
	MAX_TOTAL;
	MIN_CARD;
	MAX_CARD;
	EXACT_CARD;
	EXACT_TOTAL;
	IS_FACE;
	NOT_FACE;
	PAIR;
	NO_MATCH;
	SAME_SUIT;
	DIFF_SUIT;
	HEARTS;
	DIAMONDS;
	CLUBS;
	SPADES;
  }
  
  enum GearClass {
	FLAME;
	PIERCING;
	EXPLOSIVE;
	ELECTRICITY;
	WATER;
	SHIELD;
	MOVE;
	HEALTH;
	UTILITY;
  }