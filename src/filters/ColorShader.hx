package filters;

import zero.utilities.Color;
import openfl.display.Shader;

class ColorShader extends Shader 
{	
	
	@:glVertexSource("
		attribute float openfl_Alpha;
		attribute vec4 openfl_ColorMultiplier;
		attribute vec4 openfl_ColorOffset;
		attribute vec4 openfl_Position;
		attribute vec2 openfl_TextureCoord;
		
		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;
		
		uniform mat4 openfl_Matrix;
		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;
	
		void main(void) {
			openfl_Alphav = openfl_Alpha;
			openfl_TextureCoordv = openfl_TextureCoord;
			
			if (openfl_HasColorTransform) {
				openfl_ColorMultiplierv = openfl_ColorMultiplier;
				openfl_ColorOffsetv = openfl_ColorOffset / 255.0;
			}
			
			gl_Position = openfl_Matrix * openfl_Position;
		}
	")
	
	@:glFragmentSource("
		varying float openfl_Alphav;
		varying vec4 openfl_ColorMultiplierv;
		varying vec4 openfl_ColorOffsetv;
		varying vec2 openfl_TextureCoordv;

		uniform bool openfl_HasColorTransform;
		uniform vec2 openfl_TextureSize;
		uniform sampler2D bitmap;

		uniform vec4 color;
		uniform float uMix;

		void main(void) {
			vec4 sample = texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = mix(sample, color, uMix);
		}
	")

	public function new(color:Color) {
		super();
		data.color.value = color;
		set_mix(0);
	}

	public function set_color(color:Color) {
		data.color.value = color;
	}

	public function set_mix(amt:Float) {
		data.uMix.value = [amt];
	}
	
}