package;


import haxe.io.Bytes;
import lime.utils.AssetBundle;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {


	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	public static var rootPath:String;


	public static function init (config:Dynamic):Void {

		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();

		rootPath = null;

		if (config != null && Reflect.hasField (config, "rootPath")) {

			rootPath = Reflect.field (config, "rootPath");

		}

		if (rootPath == null) {

			#if (ios || tvos || emscripten)
			rootPath = "assets/";
			#elseif android
			rootPath = "";
			#elseif console
			rootPath = lime.system.System.applicationDirectory;
			#else
			rootPath = "./";
			#end

		}

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__fonts_oduda_ttf);
		
		#end

		var data, manifest, library, bundle;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:pathy29:images%2Fparticles%2Fpoof.pngy4:sizei452y4:typey5:IMAGEy2:idR1y7:preloadtgoR0y20:images%2Fplayers.pngR2i1752R3R4R5R7R6tgoR0y18:images%2Ftiles.pngR2i14787R3R4R5R8R6tgoR0y24:images%2Fui%2Fap_pip.pngR2i270R3R4R5R9R6tgoR0y36:images%2Fui%2Ficons%2Ficon_skull.pngR2i2850R3R4R5R10R6tgoR0y51:images%2Fui%2Ficons%2Fon_white%2Ficon_electrify.pngR2i1737R3R4R5R11R6tgoR0y49:images%2Fui%2Ficons%2Fon_white%2Ficon_explode.pngR2i2333R3R4R5R12R6tgoR0y47:images%2Fui%2Ficons%2Fon_white%2Ficon_flame.pngR2i2026R3R4R5R13R6tgoR0y46:images%2Fui%2Ficons%2Fon_white%2Ficon_move.pngR2i1973R3R4R5R14R6tgoR0y48:images%2Fui%2Ficons%2Fon_white%2Ficon_pierce.pngR2i1943R3R4R5R15R6tgoR0y48:images%2Fui%2Ficons%2Fon_white%2Ficon_shield.pngR2i1973R3R4R5R16R6tgoR0y47:images%2Fui%2Ficons%2Fon_white%2Ficon_water.pngR2i1906R3R4R5R17R6tgoR0y27:images%2Fui%2Fsuit_club.pngR2i4182R3R4R5R18R6tgoR0y30:images%2Fui%2Fsuit_diamond.pngR2i2985R3R4R5R19R6tgoR0y28:images%2Fui%2Fsuit_heart.pngR2i2540R3R4R5R20R6tgoR0y28:images%2Fui%2Fsuit_spade.pngR2i3507R3R4R5R21R6tgoR0y22:data%2Fmaps%2F000.jsonR2i1922R3y4:TEXTR5R22R6tgoR0y23:data%2Fmaps%2Fmaps.ogmoR2i19048R3R23R5R24R6tgoR2i19636R3y4:FONTy9:classNamey24:__ASSET__fonts_oduda_ttfR5y17:fonts%2Foduda.ttfR6tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		

		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		

		#end

	}


}


#if kha

null

#else

#if !display
#if flash

@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_particles_poof_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_players_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_tiles_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_ui_ap_pip_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_ui_icons_icon_skull_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_ui_icons_on_white_icon_electrify_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_ui_icons_on_white_icon_explode_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_ui_icons_on_white_icon_flame_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_ui_icons_on_white_icon_move_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_ui_icons_on_white_icon_pierce_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_ui_icons_on_white_icon_shield_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_ui_icons_on_white_icon_water_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_ui_suit_club_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_ui_suit_diamond_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_ui_suit_heart_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__images_ui_suit_spade_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__data_maps_000_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__data_maps_maps_ogmo extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__fonts_oduda_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:image("assets/images/particles/poof.png") @:noCompletion #if display private #end class __ASSET__images_particles_poof_png extends lime.graphics.Image {}
@:keep @:image("assets/images/players.png") @:noCompletion #if display private #end class __ASSET__images_players_png extends lime.graphics.Image {}
@:keep @:image("assets/images/tiles.png") @:noCompletion #if display private #end class __ASSET__images_tiles_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ui/ap_pip.png") @:noCompletion #if display private #end class __ASSET__images_ui_ap_pip_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ui/icons/icon_skull.png") @:noCompletion #if display private #end class __ASSET__images_ui_icons_icon_skull_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ui/icons/on_white/icon_electrify.png") @:noCompletion #if display private #end class __ASSET__images_ui_icons_on_white_icon_electrify_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ui/icons/on_white/icon_explode.png") @:noCompletion #if display private #end class __ASSET__images_ui_icons_on_white_icon_explode_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ui/icons/on_white/icon_flame.png") @:noCompletion #if display private #end class __ASSET__images_ui_icons_on_white_icon_flame_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ui/icons/on_white/icon_move.png") @:noCompletion #if display private #end class __ASSET__images_ui_icons_on_white_icon_move_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ui/icons/on_white/icon_pierce.png") @:noCompletion #if display private #end class __ASSET__images_ui_icons_on_white_icon_pierce_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ui/icons/on_white/icon_shield.png") @:noCompletion #if display private #end class __ASSET__images_ui_icons_on_white_icon_shield_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ui/icons/on_white/icon_water.png") @:noCompletion #if display private #end class __ASSET__images_ui_icons_on_white_icon_water_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ui/suit_club.png") @:noCompletion #if display private #end class __ASSET__images_ui_suit_club_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ui/suit_diamond.png") @:noCompletion #if display private #end class __ASSET__images_ui_suit_diamond_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ui/suit_heart.png") @:noCompletion #if display private #end class __ASSET__images_ui_suit_heart_png extends lime.graphics.Image {}
@:keep @:image("assets/images/ui/suit_spade.png") @:noCompletion #if display private #end class __ASSET__images_ui_suit_spade_png extends lime.graphics.Image {}
@:keep @:file("assets/data/maps/000.json") @:noCompletion #if display private #end class __ASSET__data_maps_000_json extends haxe.io.Bytes {}
@:keep @:file("assets/data/maps/maps.ogmo") @:noCompletion #if display private #end class __ASSET__data_maps_maps_ogmo extends haxe.io.Bytes {}
@:keep @:font("export/html5/obj/webfont/oduda.ttf") @:noCompletion #if display private #end class __ASSET__fonts_oduda_ttf extends lime.text.Font {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__fonts_oduda_ttf') @:noCompletion #if display private #end class __ASSET__fonts_oduda_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "fonts/oduda"; #else ascender = 1010; descender = -190; height = 1200; numGlyphs = 147; underlinePosition = -100; underlineThickness = 50; unitsPerEM = 1000; #end name = "Oduda Bold"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__fonts_oduda_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__fonts_oduda_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__fonts_oduda_ttf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__fonts_oduda_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__fonts_oduda_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__fonts_oduda_ttf ()); super (); }}

#end

#end
#end

#end
