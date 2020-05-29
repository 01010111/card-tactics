package ui.cards;

import scenes.Level.PlayerSprite;
import openfl.Assets;
import openfl.geom.Matrix;
import openfl.display.BitmapData;
import ui.cards.GearCard.Requirement;
import openfl.display.Sprite;

class Gear extends Sprite {

	public static var active_gear:Gear;
	
	public var link:LinkGraphic;
	public var gear_cards:Array<GearCard> = [];
	public var move_card:MoveCard;
	public var player:PlayerSprite;

	public function new(player:PlayerSprite) {
		super();
		active_gear = this;
		this.player = player;
		addChild(link = new LinkGraphic(Assets.getBitmapData('images/ui/action_arrow_white.png')));
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