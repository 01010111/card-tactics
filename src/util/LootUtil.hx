package util;

import objects.Pickup.PickupType;

class LootUtil {
	
	static var loot_pool:Array<LootData> = [];

	public static function reset(loot:Array<LootData>) {
		loot_pool = loot;
	}

	public static function get():Null<LootData> {
		if (loot_pool.length == 0) return null;
		loot_pool.shuffle();
		var out = loot_pool.shift();
		DROP.dispatch(out);
		return out;
	}

}

typedef LootData = {
	type:PickupType,
	?amt:Int,
	?id:String,
}