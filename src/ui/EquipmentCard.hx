package ui;

import openfl.display.Sprite;
import ui.DropCard.DropCardData;
import scenes.Level;
import zero.utilities.IntPoint;
import objects.GameObject;
import openfl.events.MouseEvent;

using util.CardUtil;

class EquipmentCard extends DropCard {
	
	public static var card_width:Float = 192;
	public static var card_height:Float = 224;
	public var equipment:Equipment;
	public var equipment_data:EquipmentData;
	public var equipment_position:Int;

	public function new(equipment:Equipment, position:Int) {
		super();
		this.equipment = equipment;
		this.equipment_position = position;
		draggable = false;
		addEventListener(MouseEvent.MOUSE_OVER, mouse_over);
		addEventListener(MouseEvent.MOUSE_OUT, mouse_out);
	}

	function mouse_over(e:MouseEvent) {
		
	}

	function mouse_out(e:MouseEvent) {
		
	}

	public function draw_classes(container:Sprite) {
		var class_src = switch equipment_data.equipment_class {
			default: 'images/blank.png';
			case FLAME:'images/ui/icons/on_white/icon_flame.png';
			case PIERCING:'images/ui/icons/on_white/icon_pierce.png';
			case EXPLOSIVE:'images/ui/icons/on_white/icon_explode.png';
			case ELECTRICITY:'images/ui/icons/on_white/icon_electrify.png';
			case WATER:'images/ui/icons/on_white/icon_water.png';
			case SHIELD:'images/ui/icons/on_white/icon_shield.png';
			case MOVE:'images/ui/icons/on_white/icon_move.png';
			case HEALTH:'images/ui/icons/on_white/icon_health.png';
			case UTILITY:'images/ui/icons/on_white/icon_utility.png';
		}
		var weakness_src = switch equipment_data.weakness {
			default: 'images/blank.png';
			case FLAME:'images/ui/icons/on_white/icon_flame.png';
			case PIERCING:'images/ui/icons/on_white/icon_pierce.png';
			case EXPLOSIVE:'images/ui/icons/on_white/icon_explode.png';
			case ELECTRICITY:'images/ui/icons/on_white/icon_electrify.png';
			case WATER:'images/ui/icons/on_white/icon_water.png';
			case SHIELD:'images/ui/icons/on_white/icon_shield.png';
			case MOVE:'images/ui/icons/on_white/icon_move.png';
			case HEALTH:'images/ui/icons/on_white/icon_health.png';
			case UTILITY:'images/ui/icons/on_white/icon_utility.png';
		}
		container.addChild(new Sprite().load_graphic(class_src, TOP_LEFT, true).set_position(16, 196).set_scale(0.25));
		container.addChild(new Sprite().load_graphic(weakness_src, TOP_LEFT, true).set_position(160, 196).set_scale(0.25));
		container.addChild(new Sprite().load_graphic('images/ui/icons/icon_skull.png', TOP_LEFT, true).set_position(144, 180).set_scale(0.25));
	}

	public function make_handle() {
		handle = new EquipmentHandle(equipment_data.range.max == 0 ? PRESS : AIM, this);
	}

	public function get_effect_value() {
		var out = 0;
		switch equipment_data.effect.factor {
			case VALUES:
				for (card in cards) out += card.data.value.value_to_int();
			case STATIC:
				out = equipment_data.effect.value;
			case SHIELD:
				trace(equipment.owner.shield);
				out = equipment.owner.shield;
			case HP:
				out = equipment.owner.health.current;
		}
		if (equipment_data.effect.scalar != null) out *= equipment_data.effect.scalar;
		return out;
	}

	public function get_effect_string() {
		var val = get_effect_value();
		return val == 0 ? '_' : '$val';
	}

	public function execute(?target:GameObject, ?point:IntPoint) {
		active = false;
		expended = true;
		switch equipment_data.effect.type {
			case DAMAGE:
				if (target != null) {
					target.change_health(-get_effect_value());
					for (equipment in target.equipment.equipment_cards) if (equipment.equipment_data.weakness == equipment_data.equipment_class) equipment.expended = true;
				}
			case MOVE:
				if (point != null) equipment.owner.move_to(point.x, point.y);
			case HEALTH:
				if (target != null) target.change_health(get_effect_value());
			case SHIELD:
				if (target != null) target.shield += get_effect_value();
				else equipment.owner.shield += get_effect_value();
			case DRAW:
				Level.i.deck.deal(get_effect_value());
		}
		for (card in cards) 'game_event'.dispatch({ type:USE_CARD, data: { object:equipment.owner, card_data:card.data }});
	}
	
}

typedef EquipmentData = {
	> DropCardData,
	id:String,
	effect:EffectData,
	range:RangeData,
	equipment_class:EquipmentClass,
	weakness:EquipmentClass,
}

typedef RangeData = {
	min:Int,
	max:Int,
	type:RangeType,
}

typedef EffectData = {
	type:EffectType,
	factor:EffectFactor,
	?value:Int,
	?scalar:Int,
}

enum abstract RangeType(String) {
	var NONE;
	var ORTHOGONAL;
	var DIAGONAL;
}

enum abstract EffectType(String) {
	var DAMAGE;
	var MOVE;
	var HEALTH;
	var SHIELD;
	var DRAW;
}

enum abstract EffectFactor(String) {
	var VALUES;
	var STATIC;
	var SHIELD;
	var HP;
}

enum abstract EquipmentClass(String) {
	var FLAME;
	var PIERCING;
	var EXPLOSIVE;
	var ELECTRICITY;
	var WATER;
	var SHIELD;
	var MOVE;
	var HEALTH;
	var UTILITY;
}