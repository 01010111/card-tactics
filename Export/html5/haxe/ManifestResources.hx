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

		Assets.defaultRootPath = rootPath;

		#if (openfl && !flash && !display)
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_oduda_ttf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__assets_oduda_otf);
		
		#end

		var data, manifest, library, bundle;

		#if kha

		null
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("null", library);

		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("null");

		#else

		data = '{"name":null,"assets":"aoy4:sizei19632y4:typey4:FONTy9:classNamey25:__ASSET__assets_oduda_ttfy2:idy18:assets%2Foduda.ttfy7:preloadtgoy4:pathy19:assets%2Findex.htmlR0i3962R1y4:TEXTR5R9R7tgoR8y23:assets%2Fimages%2Fk.pngR0i5420R1y5:IMAGER5R11R7tgoR8y31:assets%2Fimages%2Fnot_heart.pngR0i6691R1R12R5R13R7tgoR8y28:assets%2Fimages%2Fequals.pngR0i2845R1R12R5R14R7tgoR8y29:assets%2Fimages%2Ftilemap.pngR0i514R1R12R5R15R7tgoR8y23:assets%2Fimages%2Fj.pngR0i3382R1R12R5R16R7tgoR8y33:assets%2Fimages%2Fnot_diamond.pngR0i7020R1R12R5R17R7tgoR8y27:assets%2Fimages%2Fskull.pngR0i8909R1R12R5R18R7tgoR8y28:assets%2Fimages%2Fshield.pngR0i10571R1R12R5R19R7tgoR8y31:assets%2Fimages%2Fcard_suit.pngR0i13626R1R12R5R20R7tgoR8y23:assets%2Fimages%2F8.pngR0i6225R1R12R5R21R7tgoR8y26:assets%2Fimages%2Ffire.pngR0i9352R1R12R5R22R7tgoR8y30:assets%2Fimages%2Fnot_club.pngR0i8793R1R12R5R23R7tgoR8y23:assets%2Fimages%2F9.pngR0i5854R1R12R5R24R7tgoR8y27:assets%2Fimages%2Fempty.pngR0i1237R1R12R5R25R7tgoR8y27:assets%2Fimages%2Fspade.pngR0i6449R1R12R5R26R7tgoR8y26:assets%2Fimages%2Fmove.pngR0i8567R1R12R5R27R7tgoR8y30:assets%2Fimages%2Fpiercing.pngR0i9299R1R12R5R28R7tgoR8y28:assets%2Fimages%2Fimpact.pngR0i10210R1R12R5R29R7tgoR8y30:assets%2Fimages%2Felectric.pngR0i6743R1R12R5R30R7tgoR8y26:assets%2Fimages%2Fface.pngR0i15154R1R12R5R31R7tgoR8y34:assets%2Fimages%2Fgreater_than.pngR0i4435R1R12R5R32R7tgoR8y27:assets%2Fimages%2Fmod_x.pngR0i5039R1R12R5R33R7tgoR8y24:assets%2Fimages%2F10.pngR0i6125R1R12R5R34R7tgoR8y27:assets%2Fimages%2Fheart.pngR0i5264R1R12R5R35R7tgoR8y31:assets%2Fimages%2Fless_than.pngR0i4567R1R12R5R36R7tgoR8y25:assets%2Fimages%2Fcar.pngR0i577R1R12R5R37R7tgoR8y32:assets%2Fimages%2Fcard_value.pngR0i13912R1R12R5R38R7tgoR8y29:assets%2Fimages%2Fdiamond.pngR0i6168R1R12R5R39R7tgoR8y23:assets%2Fimages%2F4.pngR0i4699R1R12R5R40R7tgoR8y31:assets%2Fimages%2Fnot_spade.pngR0i7953R1R12R5R41R7tgoR8y23:assets%2Fimages%2F5.pngR0i5652R1R12R5R42R7tgoR8y23:assets%2Fimages%2F7.pngR0i4674R1R12R5R43R7tgoR8y23:assets%2Fimages%2FA.pngR0i5990R1R12R5R44R7tgoR8y23:assets%2Fimages%2F6.pngR0i5887R1R12R5R45R7tgoR8y26:assets%2Fimages%2Fclub.pngR0i7255R1R12R5R46R7tgoR8y23:assets%2Fimages%2F2.pngR0i5512R1R12R5R47R7tgoR8y23:assets%2Fimages%2F3.pngR0i5824R1R12R5R48R7tgoR8y23:assets%2Fimages%2Fq.pngR0i7285R1R12R5R49R7tgoR8y18:assets%2Foduda.eotR0i19906R1y6:BINARYR5R50R7tgoR8y15:assets%2FApp.tsR0i7781R1R10R5R52R7tgoR8y19:assets%2Foduda.woffR0i14748R1R51R5R53R7tgoR0i17884R1R2R3y25:__ASSET__assets_oduda_otfR5y18:assets%2Foduda.otfR7tgoR8y18:assets%2Foduda.svgR0i17884R1R10R5R56R7tgoR8y18:assets%2Fstyle.cssR0i1605R1R10R5R57R7tgoR8y22:assets%2Ftsconfig.jsonR0i5445R1R10R5R58R7tgoR8y25:assets%2Fdata%2Fgear.jsonR0i1216R1R10R5R59R7tgoR8y15:assets%2FApp.jsR0i8606R1R10R5R60R7tgh","rootPath":null,"version":2,"libraryArgs":[],"libraryType":null}';
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

@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_oduda_ttf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_index_html extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_k_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_not_heart_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_equals_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_tilemap_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_j_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_not_diamond_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_skull_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_shield_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_card_suit_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_8_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_fire_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_not_club_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_9_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_empty_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_spade_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_move_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_piercing_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_impact_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_electric_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_face_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_greater_than_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_mod_x_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_10_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_heart_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_less_than_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_car_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_card_value_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_diamond_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_4_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_not_spade_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_5_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_7_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_a_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_6_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_club_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_2_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_3_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_images_q_png extends flash.display.BitmapData { public function new () { super (0, 0, true, 0); } }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_oduda_eot extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_app_ts extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_oduda_woff extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_oduda_otf extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_oduda_svg extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_style_css extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_tsconfig_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_data_gear_json extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__assets_app_js extends null { }
@:keep @:bind @:noCompletion #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:keep @:font("Export/html5/obj/webfont/oduda.ttf") @:noCompletion #if display private #end class __ASSET__assets_oduda_ttf extends lime.text.Font {}
@:keep @:file("Assets/index.html") @:noCompletion #if display private #end class __ASSET__assets_index_html extends haxe.io.Bytes {}
@:keep @:image("Assets/images/k.png") @:noCompletion #if display private #end class __ASSET__assets_images_k_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/not_heart.png") @:noCompletion #if display private #end class __ASSET__assets_images_not_heart_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/equals.png") @:noCompletion #if display private #end class __ASSET__assets_images_equals_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/tilemap.png") @:noCompletion #if display private #end class __ASSET__assets_images_tilemap_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/j.png") @:noCompletion #if display private #end class __ASSET__assets_images_j_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/not_diamond.png") @:noCompletion #if display private #end class __ASSET__assets_images_not_diamond_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/skull.png") @:noCompletion #if display private #end class __ASSET__assets_images_skull_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/shield.png") @:noCompletion #if display private #end class __ASSET__assets_images_shield_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/card_suit.png") @:noCompletion #if display private #end class __ASSET__assets_images_card_suit_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/8.png") @:noCompletion #if display private #end class __ASSET__assets_images_8_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/fire.png") @:noCompletion #if display private #end class __ASSET__assets_images_fire_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/not_club.png") @:noCompletion #if display private #end class __ASSET__assets_images_not_club_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/9.png") @:noCompletion #if display private #end class __ASSET__assets_images_9_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/empty.png") @:noCompletion #if display private #end class __ASSET__assets_images_empty_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/spade.png") @:noCompletion #if display private #end class __ASSET__assets_images_spade_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/move.png") @:noCompletion #if display private #end class __ASSET__assets_images_move_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/piercing.png") @:noCompletion #if display private #end class __ASSET__assets_images_piercing_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/impact.png") @:noCompletion #if display private #end class __ASSET__assets_images_impact_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/electric.png") @:noCompletion #if display private #end class __ASSET__assets_images_electric_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/face.png") @:noCompletion #if display private #end class __ASSET__assets_images_face_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/greater_than.png") @:noCompletion #if display private #end class __ASSET__assets_images_greater_than_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/mod_x.png") @:noCompletion #if display private #end class __ASSET__assets_images_mod_x_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/10.png") @:noCompletion #if display private #end class __ASSET__assets_images_10_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/heart.png") @:noCompletion #if display private #end class __ASSET__assets_images_heart_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/less_than.png") @:noCompletion #if display private #end class __ASSET__assets_images_less_than_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/car.png") @:noCompletion #if display private #end class __ASSET__assets_images_car_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/card_value.png") @:noCompletion #if display private #end class __ASSET__assets_images_card_value_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/diamond.png") @:noCompletion #if display private #end class __ASSET__assets_images_diamond_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/4.png") @:noCompletion #if display private #end class __ASSET__assets_images_4_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/not_spade.png") @:noCompletion #if display private #end class __ASSET__assets_images_not_spade_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/5.png") @:noCompletion #if display private #end class __ASSET__assets_images_5_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/7.png") @:noCompletion #if display private #end class __ASSET__assets_images_7_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/A.png") @:noCompletion #if display private #end class __ASSET__assets_images_a_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/6.png") @:noCompletion #if display private #end class __ASSET__assets_images_6_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/club.png") @:noCompletion #if display private #end class __ASSET__assets_images_club_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/2.png") @:noCompletion #if display private #end class __ASSET__assets_images_2_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/3.png") @:noCompletion #if display private #end class __ASSET__assets_images_3_png extends lime.graphics.Image {}
@:keep @:image("Assets/images/q.png") @:noCompletion #if display private #end class __ASSET__assets_images_q_png extends lime.graphics.Image {}
@:keep @:file("Assets/oduda.eot") @:noCompletion #if display private #end class __ASSET__assets_oduda_eot extends haxe.io.Bytes {}
@:keep @:file("Assets/App.ts") @:noCompletion #if display private #end class __ASSET__assets_app_ts extends haxe.io.Bytes {}
@:keep @:file("Assets/oduda.woff") @:noCompletion #if display private #end class __ASSET__assets_oduda_woff extends haxe.io.Bytes {}
@:keep @:font("Export/html5/obj/webfont/oduda.otf") @:noCompletion #if display private #end class __ASSET__assets_oduda_otf extends lime.text.Font {}
@:keep @:file("Assets/oduda.svg") @:noCompletion #if display private #end class __ASSET__assets_oduda_svg extends haxe.io.Bytes {}
@:keep @:file("Assets/style.css") @:noCompletion #if display private #end class __ASSET__assets_style_css extends haxe.io.Bytes {}
@:keep @:file("Assets/tsconfig.json") @:noCompletion #if display private #end class __ASSET__assets_tsconfig_json extends haxe.io.Bytes {}
@:keep @:file("Assets/data/gear.json") @:noCompletion #if display private #end class __ASSET__assets_data_gear_json extends haxe.io.Bytes {}
@:keep @:file("Assets/App.js") @:noCompletion #if display private #end class __ASSET__assets_app_js extends haxe.io.Bytes {}
@:keep @:file("") @:noCompletion #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}



#else

@:keep @:expose('__ASSET__assets_oduda_ttf') @:noCompletion #if display private #end class __ASSET__assets_oduda_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/oduda"; #else ascender = 1010; descender = -190; height = 1200; numGlyphs = 147; underlinePosition = -100; underlineThickness = 50; unitsPerEM = 1000; #end name = "Oduda Bold"; super (); }}
@:keep @:expose('__ASSET__assets_oduda_otf') @:noCompletion #if display private #end class __ASSET__assets_oduda_otf extends lime.text.Font { public function new () { #if !html5 __fontPath = "assets/oduda"; #else ascender = 1010; descender = -190; height = 1200; numGlyphs = 145; underlinePosition = -100; underlineThickness = 50; unitsPerEM = 1000; #end name = "Oduda Bold"; super (); }}


#end

#if (openfl && !flash)

#if html5
@:keep @:expose('__ASSET__OPENFL__assets_oduda_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_oduda_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_oduda_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__assets_oduda_otf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_oduda_otf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_oduda_otf ()); super (); }}

#else
@:keep @:expose('__ASSET__OPENFL__assets_oduda_ttf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_oduda_ttf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_oduda_ttf ()); super (); }}
@:keep @:expose('__ASSET__OPENFL__assets_oduda_otf') @:noCompletion #if display private #end class __ASSET__OPENFL__assets_oduda_otf extends openfl.text.Font { public function new () { __fromLimeFont (new __ASSET__assets_oduda_otf ()); super (); }}

#end

#end
#end

#end
