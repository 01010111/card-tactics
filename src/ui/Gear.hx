package ui;

import zero.openfl.utilities.Game;
import openfl.events.Event;
import objects.Player;
import openfl.Assets;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import ui.GearCard.Requirement;
import openfl.display.Sprite;

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

	var side:PlayerSide;

	public function new(player:Player, side:PlayerSide) {
		super();
		this.player = player;
		this.side = side;
		addChild(link = new LinkGraphic(Assets.getBitmapData('images/ui/action_arrow_white.png')));
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
	}

	public function add_card(card:GearCard) {
		addChild(card);
		gear_cards.push(card);
	}
	
}

class MoveCard extends Card {
	
	public function new() {
		super();
	}

}

typedef MoveCardOptions = {
	requirement:Requirement,
	factor:MoveFactor,
	type:MoveType,
	range:Int,
}

enum MoveFactor {
	STATIC;
	VALUE;
	VALUE_HALF;
	VALUE_X_TWO;
	INFINITE;
}

enum MoveType {
	FREE;
	ROOK;
	TELEPORT;
}

class LinkGraphic extends Sprite {

	public var length:Float = 8;
	public var active:Bool = false;

	var offset_matrix:Matrix = new Matrix();
	var bitmap:BitmapData;

	public function new(bitmap:BitmapData) {
		super();
		this.bitmap = bitmap;
		offset_matrix.ty = 12;
	}

	public function draw() {
		visible = active;
		if (!active) return;
		offset_matrix.tx += 4;
		graphics.clear();
		graphics.beginBitmapFill(bitmap, offset_matrix, true, true);
		graphics.drawRect(0, -12, length, 24);
		graphics.endFill();
	}
	
}