package util;

import zero.utilities.Color;

class GameState {

	public static var state(default, set):State = USING_GEAR;
	static function set_state(s:State) {
		if ((state == PLACING_GEAR || state == PLACING_POWERUP) && s == USING_GEAR) {
			LEVEL.dolly.flash(Color.BLACK, 0.25, 0.5, 0);
		}
		if (state == USING_GEAR && (s == PLACING_GEAR || s == PLACING_POWERUP)) {
			LEVEL.dolly.flash(Color.BLACK, 0.25, 0, 0.5);
		}
		return state = s;
	}

}

enum State {
	PLACING_GEAR;
	PLACING_POWERUP;
	USING_GEAR;
	WAITING;
	ENEMY_TURN;
}