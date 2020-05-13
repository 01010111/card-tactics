package objects;

import objects.CardData.CardSuit;
import objects.CardData.CardData;
import objects.CardData.GearRequirement;
import objects.CardData.CardValue;

class CardUtil {

	public static var deck_data:Array<CardData> = [ for (suit in CardSuit.all()) for (value in CardValue.all()) { suit: suit, value: value }];

	public static function meets_requirement(data:CardData, req:GearRequirement):Bool {
		return switch req.type {
			case LESS_THAN:get_card_value(data) < req.value;
			case GREATER_THAN:get_card_value(data) > req.value;
			case EQUAL_TO:get_card_value(data) == req.value;
			case SUIT_IS:data.suit == req.suit;
			case SUIT_NOT:data.suit != req.suit;
			case IS_FACE:[JACK, QUEEN, KING].indexOf(data.value) >= 0;
			case NONE: true;
		}
	}

	public static function get_card_value(data:CardData):Int {
		return switch data.value {
			case ACE:1;
			case TWO:2;
			case THREE:3;
			case FOUR:4;
			case FIVE:5;
			case SIX:6;
			case SEVEN:7;
			case EIGHT:8;
			case NINE:9;
			case TEN:10;
			case JACK:10;
			case QUEEN:10;
			case KING:10;
		}
	}

	public static function generate_requirement_texts(req:GearRequirement):String {
		return switch req.type {
			case LESS_THAN:'a CARD with a VALUE less than ${req.value}!';
			case GREATER_THAN:'a CARD with a VALUE greater than ${req.value}!';
			case EQUAL_TO:'a CARD with a VALUE equal to ${req.value}!';
			case SUIT_IS:'a CARD with a SUIT of ${req.suit.string()}!';
			case SUIT_NOT:'a CARD that does not have a SUIT of ${req.suit.string()}!';
			case IS_FACE:'a FACE CARD!';
		}
	}

}