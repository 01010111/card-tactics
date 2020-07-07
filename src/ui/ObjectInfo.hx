package ui;

import data.Equipment;
import util.Translation;
import openfl.text.TextField;
import scenes.Level;
import openfl.events.Event;
import zero.utilities.Color;
import openfl.geom.Point;
import objects.GameObject;
import openfl.display.Sprite;

class ObjectInfo extends Sprite {

	static var info_width:Float = 160;
	static var info_height:Float = 76;
	
	public var active:Bool = false;
	
	var target:GameObject;
	var target_pos:Point;
	var global_pos:Point;

	var health_bar:Sprite;
	var title_text:TextField;
	var hp_text:TextField;

	public function new() {
		super();
		this.fill_rect(Color.BLACK, -info_width/2, -info_height/2, info_width, info_height, 16);
		this.fill_poly(Color.BLACK, [[-8, info_height/2], [8, info_height/2], [0, info_height/2 + 8]]);
		this.add(health_bar = new Sprite());
		this.add(title_text = new TextField().format({ font: Translation.get_font(BOLD), size: 14, color: Color.WHITE }));
		this.add(hp_text = new TextField().format({ font: Translation.get_font(BOLD), size: 14, color: Color.WHITE }));
		addEventListener(Event.ENTER_FRAME, update);
	}

	function update(e:Event) {
		visible = active;
		if (!active) return;
		global_pos = Level.i.dolly.localToGlobal(target_pos = new Point(target.x, target.y));
		this.set_position(global_pos.x, global_pos.y - 48 - info_height/2 - 8);
	}

	function draw_target_info(target:GameObject, ?equipment:Equipment) {
		var cur_hp = target.health.current + target.shield;
		var max_hp = target.health.max + target.shield;
		var next_hp = equipment == null ? cur_hp : cur_hp + switch equipment.data.effect.type {
			default: 0;
			case DAMAGE: -equipment.get_effect_value();
			case MOVE: 0;
			case HEALTH: equipment.get_effect_value();
			case SHIELD: 0;
		}
		next_hp = next_hp.min(max_hp).max(0).floor();

		health_bar.graphics.clear();
		health_bar.fill_rect(Color.PICO_8_DARK_BLUE, -48, -6, 96, 12, 12);
		health_bar.rect(Color.WHITE, -47, -5, 94, 10, 10, 2);
		if (cur_hp == next_hp) {
		}
		else if (cur_hp > next_hp) {
			health_bar.fill_rect(Color.PICO_8_RED, -92/2, -4, (cur_hp/max_hp * 92).max(8), 8, 8);
		}
		
		var hp = target.shield == 0 ? '${cur_hp}' : '${target.health.current}+${target.shield}';

		switch compare(cur_hp, next_hp) {
			case EQUAL_THAN:
				health_bar.fill_rect(Color.PICO_8_RED, -92/2, -4, (cur_hp/max_hp * 92).max(8), 8, 8);
				hp_text.textColor = 0xFFFFFF;
				hp += 'hp';
			case LESS_THAN:
				health_bar.fill_rect(Color.PICO_8_GREEN, -92/2, -4, (next_hp/max_hp * 92).max(8), 8, 8);
				health_bar.fill_rect(Color.PICO_8_RED, -92/2, -4, (cur_hp/max_hp * 92).max(8), 8, 8);
				hp += '+${next_hp - cur_hp}hp';
				hp_text.textColor = Color.PICO_8_GREEN.to_hex_24();
			case GREATER_THAN:
				health_bar.fill_rect(Color.PICO_8_ORANGE, -92/2, -4, (cur_hp/max_hp * 92).max(8), 8, 8);
				if (next_hp > 0) health_bar.fill_rect(Color.PICO_8_RED, -92/2, -4, (next_hp/max_hp * 92).max(8), 8, 8);
				hp += '-${cur_hp - next_hp}hp';
				hp_text.textColor = next_hp > 0 ? Color.PICO_8_ORANGE.to_hex_24() : Color.PICO_8_RED.to_hex_24();
		}

		title_text.set_string(target.title).set_position(0, -info_height/4, MIDDLE_CENTER);
		hp_text.set_string(hp).set_position(0, info_height/4, MIDDLE_CENTER);
	}

	public function set_target(target:GameObject, ?gear:Equipment) {
		draw_target_info(target, gear);
		return this.target = target;
	}

	function compare(v1:Float, v2:Float):Comparison {
		return v1 == v2 ? EQUAL_THAN : v1 > v2 ? GREATER_THAN : LESS_THAN;
	}

}

enum Comparison {
	EQUAL_THAN;
	LESS_THAN;
	GREATER_THAN;
}