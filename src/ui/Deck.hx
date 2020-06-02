package ui;

import zero.utilities.Vec2;
import openfl.display.Sprite;
import openfl.display.DisplayObject;
import zero.openfl.utilities.Game;
import zero.utilities.Timer;
import openfl.events.Event;
import openfl.display.InteractiveObject;
import ui.PlayingCard;

using zero.openfl.extensions.SpriteTools;
using zero.openfl.extensions.TextTools;
using zero.extensions.Tools;

class Deck extends Sprite {

    public static var active_deck:Deck;

	var hand:Array<PlayingCard> = [];
	var cards:Array<PlayingCardData>;

	public function new() {
        super();
        active_deck = this;
		addEventListener(Event.ENTER_FRAME, (e) -> update());
		cards = [for (suit in PlayingCardSuit.all()) for (value in PlayingCardValue.all()) { value: value, suit: suit }];
		cards.shuffle();
	}

	public function deal(amt:Int = 5) {
		for (i in 0...amt) {
			if (cards.length == 0) continue;
			var card_data = cards.pop();
			Timer.get(i * 0.1, () -> deal_card(card_data));
		}
    }
    
    public function deal_card(data:PlayingCardData) {
        var card = new PlayingCard(this, data, Game.width/2, Game.height + 128);
        add_card(card);
    }

    public function add_card(card:PlayingCard) {
        addChild(card);
        add_to_hand(card);
    }

	public function remove_from_hand(c:PlayingCard) {
		hand.remove(c);
	}

	public function add_to_hand(c:PlayingCard) {
		hand.push(c);
	}

	function update() {
		var i = 0;
		var sx = Game.width/2 - hand.length/2 * 144 + 72;
		for (card in hand) {
            var target = Vec2.get(sx + i * 144, Game.height - 48);
			card.x += (target.x - card.x) * 0.25;
            card.y += (target.y - card.y) * 0.25;
            i++;
            target.put();
		}
	}

}