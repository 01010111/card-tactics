package objects;

import openfl.events.EventType;
import openfl.events.Event;
import openfl.display.Sprite;

class GameObject extends Sprite {

	// Contructor
	public function new() {
		super();
		update.listen('update');
		resize.listen('resize');
		ev_listen(Event.REMOVED, destroy);
	}

	// Event Listening
	var ev_listener_map:Map<EventType<Dynamic>, Array<Event -> Void>> = [];
	function ev_listen(type:EventType<Dynamic>, fn:Dynamic -> Void) {
		addEventListener(type, fn);
		if (!ev_listener_map.exists(type)) ev_listener_map.set(type, []);
		ev_listener_map[type].push(fn);
	}
	function ev_unlisten(type:EventType<Dynamic>) {
		if (!ev_listener_map.exists(type)) return;
		for (ev => arr in ev_listener_map) for (fn in arr) removeEventListener(ev, fn);
		ev_listener_map.remove(type);
	}
	function ev_unlisten_all() {
		for (ev => arr in ev_listener_map) ev_unlisten(ev);
	}

	// Update
	public function update(?dt:Float) {}

	// Resize
	public function resize(?size:{ width:Float, height:Float }) {}

	// Destroy
	public function destroy(e) {
		ev_unlisten_all();
		update.unlisten('update');
		resize.unlisten('resize');
	}

}