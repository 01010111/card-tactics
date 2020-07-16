package util;

import objects.Actor.ActorData;
import objects.Player.PlayerOptions;

class PlayerData {
	
	public static var player1:ActorData = {
		id: 'Test Player',
		health: { current: 48, max: 64 },
		movement: { requirement: MAX_CARD, requirement_value: 5, type: FREE, factor: VALUE },
		equipment: ['test_d_02', 'test_m_01', 'test_m_02']
	}

	public static var player2:ActorData = {
		id: 'Test Player',
		health: { current: 64, max: 64 },
		movement: { requirement: MAX_CARD, requirement_value: 5, type: FREE, factor: VALUE },
		equipment: ['test_d_01', 'test_u_01', 'test_h_01']
	}

}