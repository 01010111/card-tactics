package util;

using zero.utilities.EventBus;

class EventUtil {
	
	public static function dispatch(ev_type:EventType, data:Dynamic) {
		'game_event'.dispatch({ type:ev_type, data:data });
	}

}

enum EventType {
	PLAYER_TURN;
	ENEMY_TURN;
	ATTACK;
	USE_CARD;
	SHIELD;
}