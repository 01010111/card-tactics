package ui;

import util.Translation;
import openfl.text.TextField;
import openfl.display.Sprite;
import zero.utilities.Color;
import data.Movement;

class MovementSprite extends DropSprite {
	
	public var movement:Movement;

	public function new(movement:Movement) {
		super();
		this.movement = movement;
		this.movement.sprite = this;
		expendable = movement;
		data = {
			requirement: movement.data.requirement,
			requirement_value: movement.data.requirement_value
		};
		draggable = false;
		anchors = [[0, 16]];
		draw();
	}

	function draw() {
		this.fill_rect(Color.BLACK, -48, -72, 96, 144, 16)
			.fill_rect(Color.get().from_int32(0xFF29ADFF), -44, -68, 88, 136, 12)
			.fill_rect(Color.get().from_int32(0xFF168AFF), -32, -24, 64, 80, 16);
		var move_type:MoveType = FREE;
		var icon_src = switch move_type {
			case FREE:'images/ui/icons/move_free.png';
			case ROOK:'images/ui/icons/move_rook.png';
			case TELEPORT:'images/ui/icons/move_teleport.png';
		}
		var req_text = new TextField().format({ font: Translation.get_font(BOLD), size: 24, color: Color.get().from_int32(0xFF083EB1) });
		var str = switch movement.data.requirement {
			default: '';
			case MIN_CARD: '>${movement.data.requirement_value - 1}';
			case MAX_CARD: '<${movement.data.requirement_value + 1}';
			case EXACT_CARD: '=${movement.data.requirement_value}';
			case IS_FACE: 'Face';
		}
		req_text.set_string(str).set_position(0, 16, MIDDLE_CENTER);
		addChild(new Sprite().load_graphic(icon_src, MIDDLE_CENTER, true).set_position(0, -48).set_scale(0.25));
		addChild(req_text);
	}

	override function add_card(card:PlayingCard) {
		super.add_card(card);
		movement.add_card(card.data);
	}

	override function remove_card(card:PlayingCard) {
		super.remove_card(card);
		movement.remove_card(card.data);
	}

}