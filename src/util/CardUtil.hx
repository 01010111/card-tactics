package util;

import ui.cards.PlayingCard.PlayingCardSuit;
import ui.cards.PlayingCard.PlayingCardValue;

class CardUtil {

	public static function value_to_string(value:PlayingCardValue) {
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

	public static function value_to_int(value:PlayingCardValue) {
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
			case KING:13;
		}
	}

	public static function int_to_value(i:Int):PlayingCardValue {
		return switch i {
			case 1: ACE;
			case 2: TWO;
			case 3: THREE;
			case 4: FOUR;
			case 5: FIVE;
			case 6: SIX;
			case 7: SEVEN;
			case 8: EIGHT;
			case 9: NINE;
			case 10: TEN;
			case 11: JACK;
			case 12: QUEEN;
			case 13: KING;
			default: ACE;
		}
	}

	public static function suit_to_string(suit:PlayingCardSuit) {
		return switch suit {
			case HEARTS:'Hearts';
			case DIAMONDS:'Diamonds';
			case CLUBS:'Clubs';
			case SPADES:'Spades';
		}
	}

}