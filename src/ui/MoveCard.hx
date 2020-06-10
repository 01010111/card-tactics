package ui;

import openfl.text.TextField;
import ui.DropCard.DropCardData;
import openfl.display.Sprite;
import zero.utilities.Color;
import ui.GearCard;

using zero.openfl.extensions.SpriteTools;
using zero.openfl.extensions.TextTools;
using util.CardUtil;
using Math;

class MoveCard extends DropCard {

	var req_text:TextField;
	var move_data:MoveData;
	
	public function new(data:MoveData) {
		super();
		this.data = {
			requirement: data.requirement,
			requirement_value: data.requirement_value
		}
		this.move_data = data;
		make_graphic();
		draggable = false;
		anchors = [[0, 16]];
	}

	function make_graphic() {
		this.fill_rect(Color.BLACK, -48, -72, 96, 144, 16).fill_rect(Color.get().from_int32(0xFF29ADFF), -44, -68, 88, 136, 12).fill_rect(Color.get().from_int32(0xFF168AFF), -32, -24, 64, 80, 16);
		var move_type:MoveType = FREE;
		var icon_src = switch move_type {
			case FREE:'images/ui/icons/move_free.png';
			case ROOK:'images/ui/icons/move_rook.png';
			case TELEPORT:'images/ui/icons/move_teleport.png';
		}
		addChild(new Sprite().load_graphic(icon_src, MIDDLE_CENTER, true).set_position(0, -48).set_scale(0.25));
		req_text = new TextField().format({ font: 'Oduda Bold', size: 24, color: Color.get().from_int32(0xFF083EB1) });
		addChild(req_text);
		set_req_text();
	}

	function set_req_text() {
		if (cards.length > 0) {
			req_text.set_string('');
			return;
		}
		var str = switch data.requirement {
			default: '';
			case MIN_CARD: '>${data.requirement_value - 1}';
			case MAX_CARD: '<${data.requirement_value + 1}';
			case EXACT_CARD: '=${data.requirement_value}';
			case IS_FACE: 'Face';
		}
		req_text.set_string(str).set_position(0, 16, MIDDLE_CENTER);
	}

	override function add_card(card:PlayingCard) {
		super.add_card(card);
		set_moves();
	}

	public function set_moves() {
		trace(get_moves_value());
	}

	public function get_moves_value():Int {
		if (cards.length == 0) return 0;
		var card = cards[0];
		return switch move_data.factor {
			case STATIC:move_data.value;
			case VALUE:card.data.value.value_to_int();
			case VALUE_HALF:(card.data.value.value_to_int()/2).floor();
			case VALUE_X_TWO:card.data.value.value_to_int() * 2;
			case INFINITE:9999;
		}
	}

}

typedef MoveData = {
	> DropCardData,
	factor:MoveFactor,
	type:MoveType,
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
