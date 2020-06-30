package ui;

import util.TurnUtil;
import objects.GameObject;
import zero.openfl.utilities.Game;
import openfl.events.Event;
import openfl.Assets;
import openfl.display.Sprite;
import objects.Player;

using zero.openfl.extensions.SpriteTools;

class Equipment extends Sprite {

	public static var active_equipment(default, set):Equipment;
	static function set_active_equipment(equipment:Equipment) {
		if (active_equipment != null) active_equipment.active = false;
		equipment.active = true;
		return active_equipment = equipment;
	}
	
	public var active:Bool = false;
	public var link:LinkGraphic;
	public var equipment_cards:Array<EquipmentCard> = [];
	public var move_card:MoveCard;
	public var owner:GameObject;
	public var player_info:PlayerInfo;

	var gear:Sprite;
	var side:PlayerSide;

	public function new(owner:GameObject, ?side:PlayerSide) {
		super();
		this.owner = owner;
		if (side != null) {
			this.side = side;
			addChild(link = new LinkGraphic(Assets.getBitmapData('images/ui/action_arrow_white.png')));
			addChild(gear = new Sprite());
			addChild(move_card = cast new MoveCard({ requirement: MAX_CARD, requirement_value: 5, type: FREE, factor: VALUE }, this).set_position(side == LEFT ? -72 : Game.width + 72, 298));
			addChild(player_info = new PlayerInfo(cast owner, side));
		}

		addEventListener(Event.ENTER_FRAME, (e) -> update());
	}

	function update() {
		move_graphics();
	}

	function move_graphics() {
		if (side == null) return;
		var i = 0;
		for (equipment in equipment_cards) {
			if (active && TurnUtil.player_turn) {
				equipment.x += ((side == LEFT ? 240 : Game.width - 240) + (side == LEFT ? 208 : -208) * i++ - equipment.x) * 0.25;
				equipment.y += (144 - equipment.y) * 0.25;
				equipment.alpha += (1 - equipment.alpha) * 0.25;
			}
			else {
				equipment.x += ((side == LEFT ? -240 : Game.width + 240) - equipment.x) * 0.25;
				equipment.y += (144 - equipment.y) * 0.25;
				equipment.alpha += (0 - equipment.alpha) * 0.25;
			}
		}
		var tx = active ? side == LEFT ? 72 : Game.width - 72 : side == LEFT ? -72 : Game.width + 72;
		move_card.x += (tx - move_card.x) * 0.25;
	}

	public function add_card(card:EquipmentCard) {
		gear.addChild(card);
		equipment_cards.push(card);
	}
	
}