package objects;

import objects.GameObject.HealthData;
import data.Movement;

class Actor extends GameObject {

	public var data:ActorData;

	public function new(data:ActorData, x:Int, y:Int) {
		this.data = data;
		super(x, y, data.health, data.id);
	}

}

typedef ActorData = {
	id:String,
	equipment:Array<String>,
	movement:MoveData,
	health:HealthData,
}

enum ActorMovement {
	
}