package ui;

import openfl.events.MouseEvent;

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

}

typedef EquipmentData = {
	effect:EffectData,
	range:RangeData,
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