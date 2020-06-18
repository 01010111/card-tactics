package ui;

import zero.utilities.IntPoint;
import ui.DropCard.Requirement;
import ui.EquipmentCard.EquipmentData;
import ui.DropCard.DropCardData;
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
import ui.PlayingCard;

using zero.openfl.extensions.SpriteTools;
using zero.openfl.extensions.TextTools;
using Math;
using util.CardUtil;
using util.Translation;
using zero.extensions.Tools;

class GearCard extends EquipmentCard {
	
	public var gear_data:GearData;
	var description:TextField;
	var req_text:TextField;
	var req_text_r:TextField;
		
	public function new(equipment:Equipment, data:GearData) {
		super(equipment);
		this.gear_data = data;
		this.equipment_data = data;
		this.data = data;
		anchors = [[-35, 28], [35, 28]];
		draw_card();
	}

	override function mouse_over(e:MouseEvent) {
		if (!expended && gear_data.range.max > 0) Level.i.draw_indicators(this);
	}
	
	override function mouse_out(e:MouseEvent) {
		if (!active) Level.i.clear_indicators();
	}
	
	function draw_card() {
		// Back
		{
			this.fill_rect(Color.get().from_int32(0xFF7CB11F), -EquipmentCard.card_width/2, -EquipmentCard.card_height/2, EquipmentCard.card_width, EquipmentCard.card_height, 16);
			this.rect(Color.BLACK, -EquipmentCard.card_width/2 + 2, -EquipmentCard.card_height/2 + 2, EquipmentCard.card_width - 4, EquipmentCard.card_height - 4, 12, 4);
		}
		
		// Contents
		{
			var contents = new Sprite();
			contents.set_position(-EquipmentCard.card_width/2, -EquipmentCard.card_height/2);
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
				var title = new TextField().format({ font: Translation.get_font(BOLD), size: 16, color: Color.BLACK }).set_string(Translation.get_equipment_title(gear_data.id)).set_position(40, 38, MIDDLE_LEFT);
				contents.add(title);
			}

			// Description
			{
				description = new TextField().format({ font: Translation.get_font(BOLD), size: 14, color: Color.BLACK, leading: -2 });
				contents.add(description);
				set_description();
			}
		
			// Drop box
			{
				contents.add(new Sprite().fill_rect(Color.PICO_8_DARK_GREEN, 16, 92, 160, 96, 16));

				req_text = new TextField().format({ font: Translation.get_font(BOLD), size: 20, color: Color.PICO_8_DARK_BLUE });
				contents.add(req_text);
				set_req_text();

				req_text_r = new TextField().format({ font: Translation.get_font(BOLD), size: 16, color: Color.PICO_8_DARK_BLUE, align: TextFormatAlign.CENTER });
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
				var class_src = switch gear_data.equipment_class {
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
		addChild(highlight = new Sprite().rect(Color.PICO_8_WHITE, -EquipmentCard.card_width/2 + 4, -EquipmentCard.card_height/2 + 4, EquipmentCard.card_width - 8, EquipmentCard.card_height - 8, 16, 8));
		Tween.get(highlight).from_to('scaleX', 1, 1.1).from_to('scaleY', 1, 1.1).from_to('alpha', 1, 0).type(LOOP_FORWARDS).duration(1).ease(Ease.quadOut);
		highlight.visible = false;

		// Handle
		handle = new EquipmentHandle(gear_data.range.max == 0 ? PRESS : AIM, this);
	}

	function set_description() {
		var str = switch gear_data.effect.type {
			case DAMAGE: 'gear_desc_damage'.get_gameplay_text().replace(get_effect_string());
			case MOVE: 'gear_desc_move'.get_gameplay_text().replace(get_effect_string());
			case SHIELD: 'gear_desc_shield'.get_gameplay_text().replace(get_effect_string());
			case HEALTH: 'gear_desc_health'.get_gameplay_text().replace(get_effect_string());
			case DRAW: 'gear_desc_draw'.get_gameplay_text().replace(get_effect_string());
		}
		description.set_string(str.wrap_string(description, 128)).set_position(EquipmentCard.card_width/2, 70, MIDDLE_CENTER);
	}

	function set_req_text() {
		if (cards.length > 0) {
			req_text.set_string('');
			return;
		}
		var str = switch gear_data.requirement {
			default: '';
			case MIN_TOTAL:'gear_req_min_total'.get_gameplay_text().replace('${gear_data.requirement_value - 1}');
			case MAX_TOTAL:'gear_req_max_total'.get_gameplay_text().replace('${gear_data.requirement_value + 1}');
			case MIN_CARD:'gear_req_min_card'.get_gameplay_text().replace('${gear_data.requirement_value - 1}');
			case MAX_CARD:'gear_req_max_card'.get_gameplay_text().replace('${gear_data.requirement_value + 1}');
			case EXACT_CARD:'gear_req_exact_card'.get_gameplay_text().replace('${gear_data.requirement_value}');
			case EXACT_TOTAL:'gear_req_exact_total'.get_gameplay_text().replace('${gear_data.requirement_value}');
			case IS_FACE:'gear_req_face'.get_gameplay_text();
			case NOT_FACE:'gear_req_not_face'.get_gameplay_text();
			case PAIR:'gear_req_pair'.get_gameplay_text();
			case NO_MATCH:'gear_req_no_match'.get_gameplay_text();
			case SAME_SUIT:'gear_req_same_suit'.get_gameplay_text();
			case DIFF_SUIT:'gear_req_diff_suit'.get_gameplay_text();
			case HEARTS:'gear_req_hearts'.get_gameplay_text();
			case DIAMONDS:'gear_req_diamonds'.get_gameplay_text();
			case CLUBS:'gear_req_clubs'.get_gameplay_text();
			case SPADES:'gear_req_spades'.get_gameplay_text();
			case TWO_CARDS:'gear_req_two_cards'.get_gameplay_text();
		}
		req_text.set_string(str).set_position(EquipmentCard.card_width/2, 140, MIDDLE_CENTER);
	}

	function set_req_text_r() {
		if (cards.length == 0 || cards.length == 2) {
			req_text_r.set_string('');
			return;
		}
		var str = switch gear_data.requirement {
			default: '';
			case MIN_TOTAL:'gear_req_sm_min_total'.get_gameplay_text().replace('${(gear_data.requirement_value - 1 - cards[0].data.value.value_to_int()).max(0)}');
			case MAX_TOTAL:'gear_req_sm_max_total'.get_gameplay_text().replace('${gear_data.requirement_value + 1 - cards[0].data.value.value_to_int()}');
			case MIN_CARD:'gear_req_sm_min_card'.get_gameplay_text().replace('${gear_data.requirement_value - 1}');
			case MAX_CARD:'gear_req_sm_max_card'.get_gameplay_text().replace('${gear_data.requirement_value + 1}');
			case EXACT_CARD:'gear_req_sm_exact_card'.get_gameplay_text().replace('${gear_data.requirement_value}');
			case EXACT_TOTAL:'gear_req_sm_exact_total'.get_gameplay_text().replace('${gear_data.requirement_value - cards[0].data.value.value_to_int()}');
			case IS_FACE:'gear_req_sm_face'.get_gameplay_text();
			case NOT_FACE:'gear_req_sm_not_face'.get_gameplay_text().split(' ').join('\n');
			case PAIR:'gear_req_sm_pair'.get_gameplay_text().replace('${cards[0].data.value.value_to_string()}');
			case NO_MATCH:'gear_req_sm_no_match'.get_gameplay_text().replace('\n${cards[0].data.value.value_to_string()}');
			case SAME_SUIT:'gear_req_sm_same_suit'.get_gameplay_text().replace('${cards[0].data.suit.suit_to_string()}');
			case DIFF_SUIT:'gear_req_sm_diff_suit'.get_gameplay_text().replace('\n${cards[0].data.suit.suit_to_string()}');
			case HEARTS:'gear_req_sm_hearts'.get_gameplay_text();
			case DIAMONDS:'gear_req_sm_diamonds'.get_gameplay_text();
			case CLUBS:'gear_req_sm_clubs'.get_gameplay_text();
			case SPADES:'gear_req_sm_spades'.get_gameplay_text();
			case TWO_CARDS:'gear_req_sm_two_cards'.get_gameplay_text();
		}
		req_text_r.set_string(str).set_position(EquipmentCard.card_width/2 + 36, 140, MIDDLE_CENTER);
	}

	override public function get_effect_value() {
		var out = super.get_effect_value();
		if (vefify_bonus()) {
			switch gear_data.bonus.type {
				case DOUBLE_EFFECT_VALUE: out *= 2;
				case EFFECT_PLUS_ONE: out += 1;
				case EFFECT_PLUS_TWO: out += 2;
				case DOUBLE_RANGE, RANGE_PLUS_ONE, RANGE_PLUS_TWO: {}
			}
		}
		return out;
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
	> EquipmentData,
	cost:Int,
	bonus:BonusData,
}

typedef BonusData = {
	requirement:Requirement,
	type:BonusType,
}

enum abstract BonusType(String) {
	var DOUBLE_EFFECT_VALUE;
	var DOUBLE_RANGE;
	var EFFECT_PLUS_ONE;
	var EFFECT_PLUS_TWO;
	var RANGE_PLUS_ONE;
	var RANGE_PLUS_TWO;
}