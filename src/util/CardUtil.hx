package util;

import ui.cards.PlayingCard.PlayingCardValue;

class CardUtil {

	public static function get_value_string(value:PlayingCardValue) {
		return switch value {
			case ACE:'A';
			case TWO:'2';
			case THREE:'3';
			case FOUR:'4';
			case FIVE:'5';
			case SIX:'6';
			case SEVEN:'7';
			case EIGHT:'8';
			case NINE:'9';
			case TEN:'10';
			case JACK:'J';
			case QUEEN:'Q';
			case KING:'K';
		}
	}

	public static function get_value_value(value:PlayingCardValue) {
		return switch value {
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
			case JACK:11;
			case QUEEN:12;
			case KING:12;
		}
	}

}