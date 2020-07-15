package util;

class EventUtil {
	
	public static function dispatch(ev_type:EventType, data:Dynamic) {
		#if debug trace(ev_type, data); #end
		'game_event'.dispatch({ type:ev_type, data:data });
	}

}

enum EventType {
	PLAYER_TURN;
	ENEMY_TURN;
	ATTACK;
	USE_CARD;
	SHIELD;
	GET_GEAR;
}