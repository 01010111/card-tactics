package ui;

import zero.openfl.utilities.Game;
import openfl.events.Event;
import openfl.Assets;
import openfl.display.Sprite;
import objects.Player;

using zero.openfl.extensions.SpriteTools;

class Gear extends Sprite {

	public static var active_gear(default, set):Gear;
	static function set_active_gear(gear:Gear) {
		if (active_gear != null) active_gear.active = false;
		gear.active = true;
		return active_gear = gear;
	}
	
	public var active:Bool = false;
	public var link:LinkGraphic;
	public var gear_cards:Array<GearCard> = [];
	public var move_card:MoveCard;
	public var player:Player;
	public var player_info:PlayerInfo;

	var gear:Sprite;
	var side:PlayerSide;

	public function new(player:Player, side:PlayerSide) {
		super();
		this.player = player;
		this.side = side;
		addChild(link = new LinkGraphic(Assets.getBitmapData('images/ui/action_arrow_white.png')));
		addChild(gear = new Sprite());
		addChild(move_card = cast new MoveCard({ requirement: MAX_CARD, requirement_value: 5, type: FREE, factor: VALUE }, this).set_position(side == LEFT ? -72 : Game.width + 72, 298));
		addChild(player_info = new PlayerInfo(player, side));

		addEventListener(Event.ENTER_FRAME, (e) -> update());
	}

	function update() {
		var i = 0;
		for (gear in gear_cards) {
			if (active) {
				gear.x += ((side == LEFT ? 240 : Game.width - 240) + (side == LEFT ? 208 : -208) * i++ - gear.x) * 0.25;
				gear.y += (144 - gear.y) * 0.25;
				gear.alpha += (1 - gear.alpha) * 0.25;
			}
			else {
				gear.x += ((side == LEFT ? -240 : Game.width + 240) - gear.x) * 0.25;
				gear.y += (144 - gear.y) * 0.25;
				gear.alpha += (0 - gear.alpha) * 0.25;
			}
		}
		var tx = active ? side == LEFT ? 72 : Game.width - 72 : side == LEFT ? -72 : Game.width + 72;
		move_card.x += (tx - move_card.x) * 0.25;
	}

	public function add_card(card:GearCard) {
		gear.addChild(card);
		gear_cards.push(card);
	}
	
}