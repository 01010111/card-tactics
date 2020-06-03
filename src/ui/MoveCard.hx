package ui;

import openfl.display.Sprite;
import zero.utilities.Color;
import ui.GearCard;

using zero.openfl.extensions.SpriteTools;

class MoveCard extends Card {
	
	public function new() {
		super();

		make_graphic();
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
	}

}

typedef MoveData = {
	requirement:Requirement,
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
