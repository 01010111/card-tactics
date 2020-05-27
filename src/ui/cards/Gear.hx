package ui.cards;

import ui.cards.GearCard.Requirement;
import openfl.display.Sprite;

class Gear extends Sprite {

    public static var active_gear:Gear;

    public var gear_cards:Array<GearCard> = [];
    public var move_card:MoveCard;

    public function new() {
        super();
        active_gear = this;
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

