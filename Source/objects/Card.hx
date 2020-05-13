package objects;

import openfl.display.Stage;
import openfl.events.Event;
import zero.utilities.Vec2;
import openfl.events.MouseEvent;
import zero.utilities.Color;
import openfl.display.Sprite;

using util.SpriteTools;

class Card extends GameObject {
	
	static var card_width:Float = 128;
	static var card_height:Float = 192;
	static var card_radius:Float = 8;

	var cursor_offset:Vec2;
	var dragging:Bool = false;
	var target:Vec2;
	var active:Bool = true;
	var draggable:Bool = true;

	public function new(x:Float, y:Float) {
		super();
		this.x = x;
		this.y = y;
		target = [x, y];
		this.fill_rect(Color.PICO_8_WHITE, -card_width/2, -card_height/2, card_width, card_height, card_radius);
		buttonMode = true;
		ev_listen(MouseEvent.MOUSE_DOWN, pickup);
		CardContainer.i.add(this);
	}
	
	override function __setStageReference(stage:Stage) {
		stage.addEventListener(MouseEvent.MOUSE_UP, drop);
		super.__setStageReference(stage);
	}

	function pickup(e:MouseEvent) {
		if (!active || !draggable) return;
		dragging = true;
		cursor_offset = [x - e.stageX, y - e.stageY];
	}

	override function update(?dt) {
		drag();
		update_position();
	}

	function drag() {
		if (!dragging) return;
		target = [stage.mouseX + cursor_offset.x, stage.mouseY + cursor_offset.y];
	}
	
	function update_position() {
		x += (target.x - x) * 0.2;
		y += (target.y - y) * 0.2;
		rotation += ((target.x - x)/10 - rotation) * 0.2;
	}

	function drop(e) {
		dragging = false;
	}

	override function destroy(e:MouseEvent) {
		super.destroy(e);
		stage.removeEventListener(MouseEvent.MOUSE_UP, drop);
	}

}