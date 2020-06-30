package ui;

import util.TurnUtil;
import zero.openfl.utilities.Game;
import openfl.events.MouseEvent;
import openfl.display.Sprite;

class Card extends Sprite {

	public var draggable:Bool = true;
	public var dragging:Bool = false;
	
	public function new() {
		super();
		addEventListener(MouseEvent.MOUSE_DOWN, (e) -> if (TurnUtil.player_turn) mouse_down(e));
		Game.root.addEventListener(MouseEvent.MOUSE_UP, mouse_up);
	}
	
	function mouse_down(e:MouseEvent) {
		if (!draggable) return;
		this.startDrag();
		dragging = true;
	}
	
	function mouse_up(e:MouseEvent) {
		if (!dragging) return;
		this.stopDrag();
		dragging = false;
	}
	
}