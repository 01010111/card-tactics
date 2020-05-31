package objects;

import openfl.display.Sprite;

class GameObject extends Sprite {

	public var health:HealthData;
	public var title:String;

	public function new(health:Int, title:String) {
		this.health = {
			current: health,
			max: health,
		};
		this.title = title;
		super();
	}

	public function change_health(delta:Float) {
		health.current += delta;
		if (health.current <= 0) kill();
	}

	function kill() {
		
	}

}

typedef HealthData = {
	current:Float,
	max:Float,
}