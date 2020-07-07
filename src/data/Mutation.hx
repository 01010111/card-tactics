package data;

import ui.PlayingCard.PlayingCardData;
import data.Equipment;

using util.CardUtil;

class Mutation extends Equipment {

	public var mutant_data:MutantData;

	public function new(inventory:Inventory, position:Int, data:MutantData) {
		super(inventory, position, data);
		mutant_data = data;
		this.data = data;
		listen.listen('game_event');
	}

	function listen(?ev:{ type:EventType, data:Dynamic }) {
		if (mutant_data.listen != ev.type) return;
		switch ev.type {
			case PLAYER_TURN:
			case ENEMY_TURN:
			case ATTACK:
			case USE_CARD: if (ev.data.object == inventory.owner) check_card(ev.data.card_data);
			case SHIELD: if (ev.data.object == inventory.owner) available = ev.data.value > 0;
		}
	}

	function check_card(card_data:PlayingCardData) {
		switch data.requirement {
			case MIN_CARD:	if (card_data.value.value_to_int() >= data.requirement_value) execute(inventory.owner);
			case MAX_CARD:	if (card_data.value.value_to_int() <= data.requirement_value) execute(inventory.owner);
			case EXACT_CARD:if (card_data.value.value_to_int() == data.requirement_value) execute(inventory.owner);
			case IS_FACE:	if (card_data.value.value_to_int() >= 11) execute(inventory.owner);
			case NOT_FACE:	if (card_data.value.value_to_int() <= 10) execute(inventory.owner);
			case HEARTS:	if (card_data.suit == HEARTS) execute(inventory.owner);
			case DIAMONDS:	if (card_data.suit == DIAMONDS) execute(inventory.owner);
			case CLUBS:		if (card_data.suit == CLUBS) execute(inventory.owner);
			case SPADES:	if (card_data.suit == SPADES) execute(inventory.owner);
			default: return;
		}
		expended = false;
	}
	
}

typedef MutantData = {
	> EquipmentData,
	?listen:EventType,
}