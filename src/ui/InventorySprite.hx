package ui;

import data.Mutation;
import data.Gear;
import util.TurnUtil;
import openfl.events.Event;
import zero.openfl.utilities.Game;
import objects.Player.PlayerSide;
import data.Inventory;
import openfl.display.Sprite;

class InventorySprite extends Sprite {
	
	public static var editting:Bool = false;
	public static var active_inventory(default, set):InventorySprite;

	static function set_active_inventory(inventory:InventorySprite) {
		if (active_inventory != null) active_inventory.active = false;
		inventory.active = true;
		return active_inventory = inventory;
	}

	public var active:Bool = false;
	public var link:LinkGraphic;
	public var inventory:Inventory;
	public var equipment:Array<EquipmentSprite> = [];

	var equipment_layer:Sprite;
	var side:PlayerSide;
	var placeholder_sprites:Array<Sprite> = [];
	var movement_sprite:MovementSprite;

	public function new(inventory:Inventory, side:PlayerSide) {
		super();
		this.inventory = inventory;
		this.inventory.sprite = this;
		this.side = side;
		make_placeholders();
		addChild(link = new LinkGraphic());
		addChild(equipment_layer = new Sprite());
		load_equipment_sprites();
		addChild(movement_sprite = cast new MovementSprite(inventory.movement).set_position(side == LEFT ? -144 : 144, 218));
		addEventListener(Event.ENTER_FRAME, (e) -> update());
	}

	function make_placeholders() {
		for (i in 0...Inventory.max_equipment) {
			var s = new Sprite().load_graphic('images/ui/card_bg.png', MIDDLE_CENTER, true).set_position(side == LEFT ? -72 : Game.width + 72, 298);
			placeholder_sprites.push(s);
			addChild(s);
		}
	}

	function load_equipment_sprites() {
		for (eq in inventory.equipment) {
			if (eq.is(Gear)) {
				var gear = new GearSprite(cast eq);
				equipment_layer.add(gear);
				equipment.push(gear);
			}
			if (eq.is(Mutation)) {
				var mutation = new MutationSprite(cast eq);
				equipment_layer.add(mutation);
				equipment.push(mutation);
			}
		}
	}

	function update() {
		move_graphics();
	}

	function move_graphics() {
		for (i in 0...placeholder_sprites.length) {
			var s = placeholder_sprites[i];
			var tx = switch active {
				case true: (side == LEFT ? 240 : Game.width - 240) + (side == LEFT ? 208 : -208) * i;
				case false: (side == LEFT ? -240 : Game.width + 240);
			}
			s.x += (tx - s.x) * 0.25;
			s.y += (144 - s.y) * 0.25;
			s.visible = editting;
		}
		for (i in 0...equipment.length) {
			var s = equipment[i];
			if (s.dragging) continue;
			s.draggable = editting;
			if (active && TurnUtil.player_turn) {
				s.x += ((side == LEFT ? 168 : -168) + (side == LEFT ? 208 : -208) * s.equipment.position - s.x) * 0.25;
				s.y += (64 - s.y) * 0.25;
				s.alpha += (1 - s.alpha) * 0.25;
			}
			else {
				s.x += ((side == LEFT ? -168 : 168) - s.x) * 0.25;
				s.y += (64 - s.y) * 0.25;
				s.alpha += (0 - s.alpha) * 0.25;
			}
		}
		var tx = active ? 0 : side == LEFT ? -144 : 144;
		movement_sprite.x += (tx - movement_sprite.x) * 0.25;
	}

	public function add_equipment(eq:EquipmentSprite) {
		equipment_layer.addChild(eq);
		equipment.push(eq);
		inventory.add_equipment(eq.equipment);
	}

	public function remove_equipment(eq:EquipmentSprite) {
		if (!equipment.remove(eq)) return;
		equipment_layer.removeChild(eq);
		inventory.remove_equipment(eq.equipment);
	}

}