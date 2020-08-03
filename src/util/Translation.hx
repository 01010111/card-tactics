package util;

import openfl.Assets;

using Reflect;
using StringTools;

class Translation {

	public static var language:String = 'en';

	static var equipment_titles:TranslationMap;
	static var gameplay:TranslationMap;
	static var mutant_descriptions:TranslationMap;
	static var tooltip_text:TranslationMap;
	static var ui_text:TranslationMap;
	
	static var fonts:Map<Font, Map<String, String>> = [];

	public static function init() {
		equipment_titles = map(Assets.getText('data/translations/equipment_titles.jsonc').parse_json());
		gameplay = map(Assets.getText('data/translations/gameplay.jsonc').parse_json());
		mutant_descriptions = map(Assets.getText('data/translations/mutant_descriptions.jsonc').parse_json());
		tooltip_text = map(Assets.getText('data/translations/tooltip_text.jsonc').parse_json());
		ui_text = map(Assets.getText('data/translations/ui.jsonc').parse_json());

		for (font in Font.all()) {
			fonts.set(font, []);
			for (ln in languages) {
				fonts[font].set(cast ln, 'Nunito Black');
			}
		}
		fonts[BOLD].set('en', 'Oduda Bold');
	}

	public static function map(data:Dynamic):TranslationMap {
		var out:TranslationMap = [];
		for (f in data.fields()) {
			var set:Map<String, String> = [];
			var set_data:Dynamic = data.field(f);
			for (ff in set_data.fields()) {
				set.set(ff, set_data.field(ff));
			}
			out.set(f, set);
		}
		return out;
	}
	
	public static function get_equipment_title(id:String):String {
		return equipment_titles[id][language];
	}

	public static function get_mutant_description(id:String):String {
		return mutant_descriptions[id][language];
	}
	
	public static function get_gameplay_text(id:String):String {
		return gameplay[id][language];
	}

	public static function get_tooltip_text(id:String):String {
		return tooltip_text[id][language];
	}

	public static function get_ui_text(id:String):String {
		return ui_text[id][language];
	}

	public static function replace(str:String, v:String):String {
		return str.replace('$', v);
	}

	public static function get_font(font:Font) {
		return fonts[font][language];
	}

	static var languages = ['en','af','sq','am','ar','hy','az','eu','be','bn','bs','bg','ca','ceb','zh','zh_CN','zh_TW','co','hr','cs','da','nl','eo','et','fi','fr','fy','gl','ka','de','el','gu','ht','ha','haw','he','hi','hmn','hu','is','ig','id','ga','it','ja','jw','kn','kk','km','ko','ku','ky','lo','la','lv','lt','lb','mk','mg','ms','ml','mt','mi','mr','mn','my','ne','no','ny','ps','fa','pl','pt','pa','ro','ru','sm','gd','sr','st','sn','sd','si','sk','sl','so','es','su','sw','sv','tl','tg','ta','te','th','tr','uk','ur','uz','vi','cy','xh','yi','yo','zu'];
	static var supported_languages = ['en'];
	
}

typedef TranslationMap = Map<String, Map<String, String>>;

enum Font {
	BOLD;
}