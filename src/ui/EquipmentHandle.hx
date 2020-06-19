package ui;

import objects.GameObject;
import scenes.Level;
import openfl.geom.Point;
import zero.utilities.Tween;
import zero.utilities.Ease;
import zero.openfl.utilities.Game;
import openfl.events.MouseEvent;
import openfl.events.Event;
import zero.utilities.Vec2;
import openfl.display.Sprite;

using zero.openfl.extensions.SpriteTools;
using Math;

class EquipmentHandle extends Sprite {

	var active:Bool = false;
	var type:HandleType;
	var graphic:Sprite;
	var home:Vec2 = [];
	var dragging:Bool = false;
	var equipment_card:EquipmentCard;
	var level_pos:Point;
	var target:Null<GameObject>;

	public function new(type:HandleType, parent:EquipmentCard) {
		super();
		equipment_card = parent;
		this.type = type;
		this.add(graphic = new Sprite());
		addEventListener(Event.ENTER_FRAME, update);
		addEventListener(MouseEvent.MOUSE_OVER, mouse_over);
		switch type {
			case AIM:
				graphic.load_graphic('images/ui/aim_cta.png', MIDDLE_CENTER, true);
				addEventListener(MouseEvent.MOUSE_DOWN, mouse_down);
				addEventListener(MouseEvent.MOUSE_OUT, (e) -> if (!dragging) Level.i.clear_indicators());
				Game.root.addEventListener(MouseEvent.MOUSE_UP, mouse_up);
			case PRESS:
				graphic.load_graphic('images/ui/do_cta.png', MIDDLE_CENTER, true);
				addEventListener(MouseEvent.MOUSE_DOWN, on_click);
				addEventListener(MouseEvent.MOUSE_OUT, mouse_out);
		}
		this.set_scale(0);
	}

	function mouse_over(e:MouseEvent) {
		if (type == PRESS) equipment_card.active = true;
		else Level.i.draw_indicators(equipment_card);
	}

	function mouse_out(e:MouseEvent) {
		equipment_card.active = false;
	}

	function mouse_down(e:MouseEvent) {
		if (!active) return;
		startDrag(true);
		dragging = true;
		equipment_card.active = true;
	}
	
	function mouse_up(e:MouseEvent) {
		if (!dragging) return;
		stopDrag();
		dragging = false;
		Equipment.active_equipment.link.length = 0;
		Equipment.active_equipment.link.draw();
		equipment_card.active = false;
		level_pos = get_level_pos();
		Level.i.clear_indicators();
		if (target != null) {
			var execute = false;
			var target_grid_pos = target.grid_pos;
			for (pos in Level.i.available_tiles) if (pos.equals(target_grid_pos)) execute = true;
			target_grid_pos.put();
			if (!execute) return;
			equipment_card.execute(target);
			Level.i.info_layer.show_info(target);
			hide();
		}
	}

	function get_level_pos() {
		return level_pos = Level.i.level.globalToLocal(new Point(x, y));
	}

	function on_click(e:MouseEvent) {
		if (!active) return;
		Tween.get(this).from_to('scaleX', 0.5, 1).from_to('scaleY', 0.5, 1).ease(Ease.elasticOut).duration(0.4).on_complete(hide);
		equipment_card.execute();
	}

	public function show() {
		if (active) return;
		if (parent == null) Equipment.active_equipment.add(this);
		active = true;
		Tween.get(this).from_to('scaleX', 0, 1).from_to('scaleY', 0, 1).from_to('alpha', 1, 1).duration(0.4).ease(Ease.backOut);
	}
	
	public function hide() {
		if (!active) return;
		active = false;
		Tween.get(this).from_to('scaleX', 1, 0).from_to('scaleY', 1, 0).from_to('alpha', 1, 0).duration(0.4).ease(Ease.backOut);
	}

	function update(e:Event) {
		Equipment.active_equipment.link.active = dragging;
		if (dragging) {
			var card_pos:Vec2 = [equipment_card.x, equipment_card.y];
			var this_pos:Vec2 = [x, y];
			var diff = this_pos - card_pos;
			Equipment.active_equipment.link.set_position(card_pos.x, card_pos.y);
			Equipment.active_equipment.link.length = diff.length;
			Equipment.active_equipment.link.rotation = diff.angle;
			card_pos.put();
			this_pos.put();
			diff.put();
			Equipment.active_equipment.link.draw();
			check_objects(x, y);
		}
		else {
			x += (equipment_card.x - x) * 0.5;
			y += (equipment_card.y + EquipmentCard.card_height/2 - y) * 0.5;
		}
	}

	function check_objects(x:Float, y:Float, ?target:GameObject) {
		level_pos = get_level_pos();
		for (object in Level.i.objects.children()) {
			var pos = Vec2.get(level_pos.x, level_pos.y);
			var obj_pos = Vec2.get(object.x, object.y);
			if (pos.distance(obj_pos) < 8) {
				target = cast object;
				var target_grid_pos = target.grid_pos;
				for (pos in Level.i.available_tiles) if (pos.equals(target_grid_pos)) Level.i.info_layer.show_info(target, false, equipment_card);
				target_grid_pos.put();
				pos.put();
				obj_pos.put();
				break;
			}
			pos.put();
			obj_pos.put();
		}
		if (target == null) Level.i.info_layer.hide_info(false);
		this.target = target;
	}

}

enum HandleType {
	AIM;
	PRESS;
}
