package data;

import data.Equipment;
import ui.PlayingCard;

using util.CardUtil;

class Gear extends Equipment {

	public var gear_data:GearData;

	public function new(inventory:Inventory, position:Int, data:GearData) {
		super(inventory, position, data);
		gear_data = data;
		this.data = data;
	}

	override function get_effect_value():Int {
		var out = super.get_effect_value();
		if (verify_bonus()) {
			switch gear_data.bonus.type {
				case DOUBLE_EFFECT_VALUE: out *= 2;
				case EFFECT_PLUS_ONE: out += 1;
				case EFFECT_PLUS_TWO: out += 2;
				case RANGE_PLUS_ONE, RANGE_PLUS_TWO, DOUBLE_RANGE:
			}
		}
		return out;
	}

	function verify_gear():Bool {
		if (cards.length == 0) return false;
		var total = 0;
		for (card in cards) total += card.value.value_to_int();
		return switch gear_data.requirement {
			case MIN_TOTAL: total >= gear_data.requirement_value;
			case MAX_TOTAL: total <= gear_data.requirement_value;
			case EXACT_TOTAL: total == gear_data.requirement_value;
			case TWO_CARDS: cards.length == 2;
			default: true;
		}
	}

	public function verify_bonus():Bool {
		if (cards.length == 0) return false;
		switch gear_data.bonus.requirement {
			case IS_FACE: for (card in cards) if (![JACK, QUEEN, KING].contains(card.value)) return false;
			case TWO_CARDS: return cards.length == 2;
			case HEARTS: for (card in cards) if (card.suit != HEARTS) return false;
			case DIAMONDS: for (card in cards) if (card.suit != DIAMONDS) return false;
			case CLUBS: for (card in cards) if (card.suit != CLUBS) return false;
			case SPADES: for (card in cards) if (card.suit != SPADES) return false;
			default: return false;
		}
		return true;
	}

	override function add_card(card:PlayingCardData) {
		super.add_card(card);
		available = verify_gear();
	}

	override function remove_card(card:PlayingCardData) {
		super.remove_card(card);
		available = verify_gear();
	}
	
}

typedef GearData = {
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