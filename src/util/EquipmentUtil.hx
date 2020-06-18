package util;

import openfl.Assets;
import ui.GearCard.GearData;
import ui.MutantCard.MutantData;

using zero.extensions.Tools;

class EquipmentUtil {

	static var gear_data:Array<GearData>;
	static var mutant_data:Array<MutantData>;

	public static function init() {
		gear_data = Assets.getText('data/gear.jsonc').parse_json();
		mutant_data = Assets.getText('data/mutant.jsonc').parse_json();
	}

	public static function id_type(id:String):IDType {
		for (data in gear_data) if (data.id == id) return GEAR;
		for (data in mutant_data) if (data.id == id) return MUTANT;
		return NONE;
	}

	public static function get_gear_data(id:String):Null<GearData> {
		for (data in gear_data) if (data.id == id) return data;
		return null;
	}

	public static function get_mutant_data(id:String):Null<MutantData> {
		for (data in mutant_data) if (data.id == id) return data;
		return null;
	}

}

enum IDType {
	NONE;
	GEAR;
	MUTANT;
}