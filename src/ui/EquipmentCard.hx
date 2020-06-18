package ui;

import ui.DropCard.DropCardData;
import scenes.Level;
import zero.utilities.IntPoint;
import objects.GameObject;
import openfl.events.MouseEvent;

using util.CardUtil;
using zero.utilities.EventBus;

class EquipmentCard extends DropCard {
	
	public static var card_width:Float = 192;
	public static var card_height:Float = 224;
	public var equipment:Equipment;
	public var equipment_data:EquipmentData;

	public function new(equipment:Equipment) {
		super();
		this.equipment = equipment;
		draggable = false;
		addEventListener(MouseEvent.MOUSE_OVER, mouse_over);
		addEventListener(MouseEvent.MOUSE_OUT, mouse_out);
	}

	function mouse_over(e:MouseEvent) {
		
	}

	function mouse_out(e:MouseEvent) {
		
	}

	public function get_effect_value() {
		var out = 0;
		switch equipment_data.effect.factor {
			case VALUES:
				for (card in cards) out += card.data.value.value_to_int();
			case STATIC:
				out = equipment_data.effect.value;
		}
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
		for (card in cards) 'game_event'.dispatch({
			type:USE_CARD,
			data: {
				object:equipment.owner,
				card_data:card.data
			}
		});
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
	var MUTANT;
}