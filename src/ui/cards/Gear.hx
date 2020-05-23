package ui.cards;

import openfl.display.Sprite;

class Gear extends Sprite {

    public static var active_gear:Gear;

    public var gear_cards:Array<GearCard> = [];

    public function new() {
        super();
        active_gear = this;
    }

    public function add_card(card:GearCard) {
        addChild(card);
        gear_cards.push(card);
    }
    
}