package ui;

import ui.DropCard.DropCardData;
import openfl.filters.ColorMatrixFilter;
import objects.GameObject;
import scenes.Level;
import openfl.events.MouseEvent;
import openfl.text.TextFormatAlign;
import zero.utilities.Ease;
import zero.utilities.Tween;
import openfl.text.TextField;
import openfl.display.Sprite;
import zero.utilities.Color;
import openfl.events.Event;
import zero.utilities.Vec2;
import ui.PlayingCard;

using zero.openfl.extensions.SpriteTools;
using zero.openfl.extensions.TextTools;
using Math;
using util.CardUtil;
using zero.extensions.Tools;

class GearCard extends DropCard {
	
	public static var card_width:Float = 192;
	public static var card_height:Float = 224;
	public var gear:Gear;
	public var gear_data:GearData;
	var description:TextField;
	var req_text:TextField;
	var req_text_r:TextField;
		
	public function new(gear:Gear, gear_data:GearData) {
		super();
		this.gear = gear;
		this.gear_data = gear_data;
		draggable = false;
		anchors = [[-35, 28], [35, 28]];
		this.data = {
			requirement: gear_data.requirement,
			requirement_value: gear_data.requirement_value,
		};
		draw_card();
		addEventListener(MouseEvent.MOUSE_OVER, mouse_over);
		addEventListener(MouseEvent.MOUSE_OUT, mouse_out);
	}

	function mouse_over(e:MouseEvent) {
		if (!expended && gear_data.range.max > 0) Level.i.draw_indicators(this);
	}
	
	function mouse_out(e:MouseEvent) {
		if (!active) Level.i.clear_indicators();
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
				for (i in 0...gear_data.cost) {
					var pip = new Sprite().load_graphic('images/ui/ap_pip.png', TOP_LEFT, true).set_position(165 - i * 11, 10);
					contents.add(pip);
				}
			}

			// Title
			{
				contents.add(new Sprite().fill_rect(Color.PICO_8_WHITE, 26, 28, 140, 24, 24));
				var title = new TextField().format({ font: 'Oduda Bold', size: 16, color: Color.BLACK }).set_string(gear_data.title).set_position(40, 38, MIDDLE_LEFT);
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
				var src = switch gear_data.bonus.requirement {
					case IS_FACE:'images/ui/rule_face.png';
					case TWO_CARDS:'images/ui/rule_two_cards.png';
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
				var class_src = switch gear_data.gear_class {
					default: 'images/blank.png';
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
				var weakness_src = switch gear_data.weakness {
					default: 'images/blank.png';
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

		// Highlight
		addChild(highlight = new Sprite().rect(Color.PICO_8_WHITE, -card_width/2 + 4, -card_height/2 + 4, card_width - 8, card_height - 8, 16, 8));
		Tween.get(highlight).from_to('scaleX', 1, 1.1).from_to('scaleY', 1, 1.1).from_to('alpha', 1, 0).type(LOOP_FORWARDS).duration(1).ease(Ease.quadOut);
		highlight.visible = false;

		// Handle
		handle = new GearCardHandle(gear_data.range.max == 0 ? PRESS : AIM, this);
	}

	function set_description() {
		var str = switch gear_data.effect.type {
			case DAMAGE: 'Do ${get_effect_string()} damage';
			case MOVE: 'Move ${get_effect_string()} spaces';
			case SHIELD: 'Shield against ${get_effect_string()} damage';
			case HEALTH: 'Heal ${get_effect_string()} hitpoints';
			case DRAW: 'Draw ${get_effect_string()} card${get_effect_value() > 1 ? 's' : ''}';
		}
		description.set_string(str.wrap_string(description, 128)).set_position(card_width/2, 70, MIDDLE_CENTER);
	}

	function set_req_text() {
		if (cards.length > 0) {
			req_text.set_string('');
			return;
		}
		var str = switch gear_data.requirement {
			default: '';
			case MIN_TOTAL: 'All > ${gear_data.requirement_value - 1}';
			case MAX_TOTAL: 'All < ${gear_data.requirement_value + 1}';
			case MIN_CARD: '> ${gear_data.requirement_value - 1}';
			case MAX_CARD: '< ${gear_data.requirement_value + 1}';
			case EXACT_CARD: '= ${gear_data.requirement_value}';
			case EXACT_TOTAL: 'All = ${gear_data.requirement_value}';
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
			case TWO_CARDS: 'Two Cards';
		}
		req_text.set_string(str).set_position(card_width/2, 140, MIDDLE_CENTER);
	}

	function set_req_text_r() {
		if (cards.length == 0 || cards.length == 2) {
			req_text_r.set_string('');
			return;
		}
		var str = switch gear_data.requirement {
			default: '';
			case MIN_TOTAL: '> ${(gear_data.requirement_value - 1 - cards[0].data.value.value_to_int()).max(0)}';
			case MAX_TOTAL: '< ${gear_data.requirement_value + 1 - cards[0].data.value.value_to_int()}';
			case MIN_CARD: '> ${gear_data.requirement_value - 1}';
			case MAX_CARD: '< ${gear_data.requirement_value + 1}';
			case EXACT_CARD: '= ${gear_data.requirement_value}';
			case EXACT_TOTAL: '= ${gear_data.requirement_value - cards[0].data.value.value_to_int()}';
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
			case TWO_CARDS: 'Any';
		}
		req_text_r.set_string(str).set_position(card_width/2 + 36, 140, MIDDLE_CENTER);
	}

	public function get_effect_value() {
		var out = 0;
		switch gear_data.effect.factor {
			case VALUES:
				for (card in cards) out += card.data.value.value_to_int();
			case STATIC:
				out = gear_data.effect.value;
		}
		if (vefify_bonus()) {
			switch gear_data.bonus.type {
				case DOUBLE_EFFECT_VALUE: out *= 2;
				case DOUBLE_RANGE: {}
			}
		}
		return out;
	}

	public function get_effect_string() {
		var val = get_effect_value();
		return val == 0 ? '_' : '$val';
	}


	public function verify_gear():Bool {
		if (cards.length == 0) return false;
		var total = 0;
		for (card in cards) total += card.data.value.value_to_int();
		return switch gear_data.requirement {
			case MIN_TOTAL: total >= gear_data.requirement_value;
			case MAX_TOTAL: total <= gear_data.requirement_value;
			case EXACT_TOTAL: total == gear_data.requirement_value;
			case TWO_CARDS: cards.length == 2;
			default: true;
		}
	}

	public function vefify_bonus() {
		if (cards.length == 0) return false;
		switch gear_data.bonus.requirement {
			case IS_FACE: for (card in cards) if (![JACK, QUEEN, KING].contains(card.data.value)) return false;
			case TWO_CARDS: return cards.length == 2;
			case HEARTS: for (card in cards) if (card.data.suit != HEARTS) return false;
			case DIAMONDS: for (card in cards) if (card.data.suit != DIAMONDS) return false;
			case CLUBS: for (card in cards) if (card.data.suit != CLUBS) return false;
			case SPADES: for (card in cards) if (card.data.suit != SPADES) return false;
			default: return false;
		}
		return true;
	}

	public function execute(?target:GameObject) {
		active = false;
		expended = true;
		switch gear_data.effect.type {
			case DAMAGE:
				if (target != null) target.change_health(-get_effect_value());
			case MOVE:
			case HEALTH:
				if (target != null) target.change_health(get_effect_value());
			case SHIELD:
			case DRAW:
				Level.i.deck.deal(get_effect_value());
		}
	}

	override function add_card(card:PlayingCard) {
		super.add_card(card);
		set_description();
		set_req_text();
		set_req_text_r();
		verify_gear() ? handle.show() : handle.hide();
	}

	override function remove_card(card:PlayingCard) {
		super.remove_card(card);
		set_description();
		set_req_text();
		set_req_text_r();
		verify_gear() ? handle.show() : handle.hide();
	}

	override function update(e:Event) {
		super.update(e);
		highlight.visible = active;
		var rot_target = active ? (t += 0.15).sin() * 4 : 0;
		rotation += (rot_target - rotation) * 0.25;
	}

}

typedef GearData = {
	> DropCardData,
	id:String,
	title:String,
	description:String,
	cost:Int,
	gear_class:GearClass,
	weakness:GearClass,
	range:RangeData,
	effect:EffectData,
	bonus:BonusData,
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
  
  enum abstract RangeType(String) {
	var NONE;
	var ORTHOGONAL;
	var DIAGONAL;
  }
  
  enum abstract EffectType(String) {
	var DAMAGE;
	var MOVE;
	var HEALTH;
	var SHIELD;
	var DRAW;
  }
  
  enum abstract EffectFactor(String) {
	var VALUES;
	var STATIC;
  }
  
  enum abstract BonusType(String) {
	var DOUBLE_EFFECT_VALUE;
	var DOUBLE_RANGE;
  }
  
  enum abstract Requirement(String) {
	var MIN_TOTAL;
	var MAX_TOTAL;
	var MIN_CARD;
	var MAX_CARD;
	var EXACT_CARD;
	var EXACT_TOTAL;
	var IS_FACE;
	var NOT_FACE;
	var PAIR;
	var NO_MATCH;
	var SAME_SUIT;
	var DIFF_SUIT;
	var HEARTS;
	var DIAMONDS;
	var CLUBS;
	var SPADES;
	var TWO_CARDS;
  }
  
  enum abstract GearClass(String) {
	var FLAME;
	var PIERCING;
	var EXPLOSIVE;
	var ELECTRICITY;
	var WATER;
	var SHIELD;
	var MOVE;
	var HEALTH;
	var UTILITY;
  }