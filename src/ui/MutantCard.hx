package ui;

import ui.PlayingCard.PlayingCardData;
import util.EventUtil;
import zero.utilities.Color;
import util.Translation;
import openfl.text.TextField;
import scenes.Level;
import openfl.events.MouseEvent;
import ui.EquipmentCard.EquipmentData;
import ui.DropCard.DropCardData;
import openfl.display.Sprite;

using zero.openfl.extensions.SpriteTools;
using zero.openfl.extensions.TextTools;
using zero.utilities.EventBus;
using util.CardUtil;

class MutantCard extends EquipmentCard {
	
	public var mutant_data:MutantData;

	public function new(equipment:Equipment, data:MutantData) {
		super(equipment);
		this.mutant_data = data;
		this.equipment_data = data;
		this.data = data;
		draw_card();
		listen.listen('game_event');
	}

	override function mouse_over(e:MouseEvent) {
		if (!expended && mutant_data.range.max > 0) Level.i.draw_indicators(this);
	}
	
	override function mouse_out(e:MouseEvent) {
		if (!active) Level.i.clear_indicators();
	}
	
	function draw_card() {
		var back = new Sprite().load_graphic('images/ui/mutant_card.png', MIDDLE_CENTER, true).set_scale(0.25);
		this.add(back);

		var content = new Sprite().set_position(-EquipmentCard.card_width/2, -EquipmentCard.card_height/2);
		this.add(content);

		var title = new TextField().format({ font: Translation.get_font(BOLD), size: 16, color: Color.BLACK }).set_string(Translation.get_equipment_title(mutant_data.id)).set_position(40, 42, MIDDLE_LEFT);
		content.add(title);

		var description = new TextField().format({ font: Translation.get_font(BOLD), size: 14, color: Color.BLACK, leading: -2, align: CENTER });
		description.set_string(Translation.get_mutant_description(mutant_data.id).wrap_string(description, 112)).set_position(EquipmentCard.card_width/2, EquipmentCard.card_height/2 + 12, MIDDLE_CENTER);
		content.add(description);
	}

	public function verify() {
		
	}

	function listen(?ev:{ type:EventType, data:Dynamic }) {
		switch ev.type {
			case PLAYER_TURN:
			case ENEMY_TURN:
			case ATTACK:
			case USE_CARD: if (ev.data.object == equipment.owner) check_card(ev.data.card_data);
		}
	}

	function check_card(card_data:PlayingCardData) {
		switch data.requirement {
			case MIN_CARD:if (card_data.value.value_to_int() >= data.requirement_value) execute(equipment.owner);
			case MAX_CARD:if (card_data.value.value_to_int() <= data.requirement_value) execute(equipment.owner);
			case EXACT_CARD:if (card_data.value.value_to_int() == data.requirement_value) execute(equipment.owner);
			case IS_FACE:if (card_data.value.value_to_int() >= 11) execute(equipment.owner);
			case NOT_FACE:if (card_data.value.value_to_int() <= 10) execute(equipment.owner);
			case HEARTS:if (card_data.suit == HEARTS) execute(equipment.owner);
			case DIAMONDS:if (card_data.suit == DIAMONDS) execute(equipment.owner);
			case CLUBS:if (card_data.suit == CLUBS) execute(equipment.owner);
			case SPADES:if (card_data.suit == SPADES) execute(equipment.owner);
			default: return;
		}
		expended = false;
	}

}

typedef MutantData = {
	> DropCardData,
	> EquipmentData,
}