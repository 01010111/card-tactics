package objects;

import zero.utilities.IntPoint;
import openfl.display.Tile;
import openfl.geom.Rectangle;
import openfl.display.Tilemap as OTilemap;
import openfl.display.Tileset as OTileset;

using openfl.Assets;

class Tilemap extends OTilemap {

	var map:Array<Array<Int>>;
	var options:TilemapOptions;

	public function new(options:TilemapOptions) {
		super(
			options.tileset.frame_width * options.map[0].length,
			options.tileset.frame_height * options.map.length,
			new Tileset(options.tileset),
			options.smoothing
		);
		this.options = options;
		init_map(options.map, options.tileset.frame_width, options.tileset.frame_height);
	}
	
	function init_map(map:Array<Array<Int>>, w:Int, h:Int) {
		for (j in 0...map.length) for (i in 0...map[j].length) {
			addTile(new Tile(map[j][i], i * w, j * h));
		}
	}

	public function get_map(copy:Bool = true):Array<Array<Int>> {
		return copy ? map.copy() : map;
	}

	public function set_tile(x:Int, y:Int, id:Int) {
		get_tile(x, y).id = id;
		map[y][x] = id;
	}

	public function set_tile_at(x:Float, y:Float, id:Int) {
		var p = translate_float_to_map(x, y);
		get_tile(p.x, p.y).id = id;
		map[p.y][p.x] = id;
		p.put();
	}

	public function get_tile_id(x:Int, y:Int):Int {
		return get_tile(x, y).id;
	}

	public function get_tile_id_at(x:Float, y:Float) {
		var p = translate_float_to_map(x, y);
		var out = get_tile(p.x, p.y).id;
		p.put();
		return out;
	}

	function get_tile(x:Int, y:Int) {
		return getTileAt(y * map[0].length + x);
	}

	function translate_float_to_map(x:Float, y:Float):IntPoint {
		return [(x/options.tileset.frame_width).floor(), (y/options.tileset.frame_height).floor()];
	}

}

class Tileset extends OTileset {

	public function new(options:TilesetOptions) {
		super(options.image.getBitmapData());
		for (j in 0...(bitmapData.height/options.frame_height).int()) for (i in 0...(bitmapData.width/options.frame_width).int()) {
			addRect(new Rectangle(
				i * options.frame_width,
				j * options.frame_height,
				options.frame_width,
				options.frame_height
			));
		}
	}

}

typedef TilemapOptions = {
	map:Array<Array<Int>>,
	tileset:TilesetOptions,
	smoothing:Bool,
}

typedef TilesetOptions = {
	image:String,
	frame_width:Int,
	frame_height:Int,
}