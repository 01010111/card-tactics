package ui.cards;

import openfl.text.TextField;
import zero.utilities.Timer;
import openfl.display.InteractiveObject;
import zero.utilities.Vec2;
import zero.openfl.utilities.Game;
import openfl.events.Event;
import openfl.events.MouseEvent;
import zero.utilities.Color;
import openfl.display.Sprite;

using zero.openfl.extensions.SpriteTools;
using zero.openfl.extensions.TextTools;
using zero.extensions.Tools;

class Card extends Sprite {

	public var draggable:Bool = true;
	public var dragging:Bool = false;
	
	public function new() {
		super();
		addEventListener(MouseEvent.MOUSE_DOWN, mouse_down);
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