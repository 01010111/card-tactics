package util;

class EventUtil {

	static var log:Array<{ type:EventType, data:Dynamic }> = [];
	public static function dispatch(ev_type:EventType, data:Dynamic) {
		#if debug trace(ev_type, data); #end
		'game_event'.dispatch({ type:ev_type, data:data });
		log.push({ type: ev_type, data: data });
	}

}

enum EventType {
	PLAYER_TURN;
	ENEMY_TURN;
	ATTACK;
	USE_CARD;
	SHIELD;
	GET_GEAR;
	DROP;
}