package util;

import openfl.Assets;
import haxe.Json;
import haxe.DynamicAccess;

using zero.extensions.Tools;
using Std;
using Reflect;
using StringTools;

class Translation {

	public static var language:String = 'en';

	static var gear_titles:DynamicAccess<TranslationMap>;
	static var gameplay:DynamicAccess<TranslationMap>;
	
	static var fonts:Map<Font, Map<String, String>> = [];

	public static function init() {
		gear_titles = Assets.getText('data/translations/gear_titles.jsonc').parse_json();
		gameplay = Assets.getText('data/translations/gameplay.jsonc').parse_json();
		for (font in Font.all()) {
			fonts.set(font, []);
			for (ln in languages) {
				fonts[font].set(cast ln, 'Nunito Black');
			}
		}
		fonts[BOLD].set('en', 'Oduda Bold');
	}
	
	public static function get_gear_title(id:String):String {
		return gear_titles.get(id).field(cast language);
	}

	public static function get_gameplay_text(id:String):String {
		return gameplay.get(id).field(cast language);
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