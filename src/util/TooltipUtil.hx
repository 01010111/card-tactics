package util;

import openfl.events.MouseEvent;
import openfl.display.DisplayObject;

class TooltipUtil {
	
	public static function add_info(object:DisplayObject, info_id:String) {
		object.addEventListener(MouseEvent.MOUSE_OVER, (e) -> 'tooltip'.dispatch({ info: Translation.get_tooltip_text(info_id) }));
		object.addEventListener(MouseEvent.MOUSE_OUT, (e) -> 'tooltip'.dispatch({}));
	}

}