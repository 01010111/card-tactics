package data;

import util.FilterUtil;
import ui.MovementSprite;
import ui.PlayingCard.PlayingCardData;
import scenes.Level;
import interfaces.Expendable;
import objects.GameObject;
import data.Equipment.Requirement;

using util.CardUtil;

class Movement implements Expendable {
	
	public var data:MoveData;
	public var owner:GameObject;
	public var expended(default, set):Bool = false;
	public var card:PlayingCardData;
	public var sprite:MovementSprite;

	public function new(data:MoveData, owner:GameObject) {
		this.data = data;
		this.owner = owner;
	}

	public function set_moves() {
		if (expended) return;
		Level.i.draw_move_indicators(this);
	}

	public function add_card(card:PlayingCardData) {
		this.card = card;
		set_moves();
	}

	public function remove_card(card:PlayingCardData) {
		Level.i.move_indicators.graphics.clear();
		card = null;
	}

	public function get_moves_value():Int {
		if (card == null) return 0;
		return switch data.factor {
			case STATIC: data.value;
			case VALUE:	card.value.value_to_int();
			case VALUE_HALF: (card.value.value_to_int() / 2).floor();
			case VALUE_X_TWO: card.value.value_to_int() * 2;
			case INFINITE: 9999;
		}
	}

	public function execute() {
		expended = true;
		USE_CARD.dispatch({			
			object: owner,
			card_data: card
		});
	}

	function set_expended(v:Bool):Bool {
		if (sprite != null) sprite.filters = v ? [FilterUtil.grayscale_filter] : [];
		return expended = v;
	}

}

typedef MoveData = {
	factor:MoveFactor,
	type:MoveType,
	requirement:Requirement,
	?requirement_value:Int,
	?value:Int,
}

enum MoveFactor {
	STATIC;
	VALUE;
	VALUE_HALF;
	VALUE_X_TWO;
	INFINITE;
}

enum MoveType {
	FREE;
	ROOK;
	TELEPORT;
}
