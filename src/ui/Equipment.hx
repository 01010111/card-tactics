package ui;

import util.TurnUtil;
import objects.GameObject;
import zero.openfl.utilities.Game;
import openfl.events.Event;
import openfl.Assets;
import openfl.display.Sprite;
import objects.Player;

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
	public var editting:Bool = false;

	var gear:Sprite;
	var side:PlayerSide;
	var empty_sprites:Array<Sprite> = [];

	public function new(owner:GameObject, ?side:PlayerSide) {
		super();
		this.owner = owner;
		if (side != null) {
			this.side = side;
			for (i in 0...3) {
				var s = new Sprite().load_graphic('images/ui/card_bg.png', MIDDLE_CENTER, true).set_position(side == LEFT ? -72 : Game.width + 72, 298);
				addChild(s);
				empty_sprites.push(s);
			}
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
		for (i in 0...empty_sprites.length) {
			var s = empty_sprites[i];
			var tx = switch active {
				case true: (side == LEFT ? 240 : Game.width - 240) + (side == LEFT ? 208 : -208) * i;
				case false: (side == LEFT ? -240 : Game.width + 240);
			}
			s.x += (tx - s.x) * 0.25; 
			s.y += (144 - s.y) * 0.25;
			s.visible = editting;
		}
		for (equipment in equipment_cards) {
			if (equipment.dragging) continue;
			equipment.draggable = editting;
			if (active && TurnUtil.player_turn) {
				equipment.x += ((side == LEFT ? 240 : Game.width - 240) + (side == LEFT ? 208 : -208) * equipment.equipment_position - equipment.x) * 0.25;
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