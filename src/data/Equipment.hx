package data;

import util.FilterUtil;
import scenes.Level;
import zero.utilities.IntPoint;
import objects.GameObject;
import ui.PlayingCard;
import interfaces.Expendable;
import ui.EquipmentSprite;

using util.CardUtil;

class Equipment implements Expendable {
	
	public var expended(default, set):Bool = false;
	public var inventory:Inventory;
	public var data:EquipmentData;
	public var position:Int;
	public var replacable:Bool = true;
	public var cards:Array<PlayingCardData> = [];
	public var sprite:EquipmentSprite;
	public var available(default, set):Bool = false;

	public function new(inventory:Inventory, position:Int, data:EquipmentData) {
		this.inventory = inventory;
		this.position = position;
	}

	public function get_effect_value() {
		var out = 0;
		switch data.effect.factor {
			case VALUES:	for (card in cards) out += card.value.value_to_int();
			case STATIC:	out = data.effect.value;
			case SHIELD:	out = inventory.owner.shield;
			case HP:		out = inventory.owner.health.current;
		}
		if (data.effect.scalar != null) out *= data.effect.scalar;
		return out;
	}

	public function execute(?target:GameObject, ?point:IntPoint) {
		expended = true;
		switch data.effect.type {
			case DAMAGE:
				if (target == null) return;
				target.change_health(-get_effect_value());
				for (e in target.inventory.equipment) if (e.data.weakness == data.equipment_class) e.expended = true;
			case MOVE:
				if (point == null) return;
				inventory.owner.move_to(point.x, point.y);
			case HEALTH:
				if (target == null) return;
				target.change_health(get_effect_value());
			case SHIELD:
				if (target == null) inventory.owner.shield += get_effect_value();
				else target.shield += get_effect_value();
			case DRAW:
				Level.i.deck.deal(get_effect_value());
		}
		for (card in cards) USE_CARD.dispatch({
			object: inventory.owner,
			card_data: card
		});
		if (sprite != null) sprite.execute();
	}
	
	public function add_card(card:PlayingCardData) {
		cards.push(card);
	}
	
	public function remove_card(card:PlayingCardData) {
		cards.remove(card);
	}

	function set_expended(v:Bool) {
		if (sprite != null) {
			if (!v) sprite.active = false;
			sprite.filters = v ? [FilterUtil.grayscale_filter] : [];
		}
		return expended = v;
	}

	function set_available(v:Bool) {
		if (sprite != null) v ? sprite.handle.show() : sprite.handle.hide();
		return available = v;
	}

}

typedef EquipmentData = {
	id:String,
	effect:EffectData,
	range:RangeData,
	equipment_class:EquipmentClass,
	weakness:EquipmentClass,
	requirement:Requirement,
	?requirement_value:Int,
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

enum abstract Requirement(String) {
	var NONE;
	var MIN_TOTAL;
	var MAX_TOTAL;
	var MIN_CARD;
	var MAX_CARD;
	var EXACT_CARD;
	var EXACT_TOTAL;
	var IS_FACE;
	var NOT_FACE;
	var PAIR;
	var NO_MATCH;
	var SAME_SUIT;
	var DIFF_SUIT;
	var HEARTS;
	var DIAMONDS;
	var CLUBS;
	var SPADES;
	var TWO_CARDS;
}