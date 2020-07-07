package data;

import objects.Actor;
import ui.InventorySprite;
import objects.GameObject;

class Inventory {
	
	public static final max_equipment:Int = 3;

	public var owner:GameObject;
	public var equipment:Array<Equipment> = [];
	public var movement:Movement;
	public var sprite:InventorySprite;

	public function new(owner:Actor, ?equipment:Array<Equipment>) {
		this.owner = owner;
		movement = new Movement(owner.data.movement, owner);
		if (equipment != null) for (eq in equipment) add_equipment(eq);
	}

	public function add_equipment(eq:Equipment) {
		equipment.push(eq);
	}

	public function remove_equipment(eq:Equipment) {
		equipment.remove(eq);
	}

}