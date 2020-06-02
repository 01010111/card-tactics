package util;

import openfl.Assets;
import ui.GearCard.GearData;

using zero.extensions.Tools;

class GearUtil {

	static var gear_data:Array<GearData>;

	public static function init() gear_data = Assets.getText('data/gear.jsonc').parse_json();

	public static function get_gear_data(id:String) {
		for (gear in gear_data) if (gear.id == id) return gear;
		return null;
	}

}