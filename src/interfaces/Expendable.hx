package interfaces;

interface Expendable {
	public var expended(default, set):Bool;
	private function set_expended(v:Bool):Bool;
}