package filters;

import zero.utilities.Color;
import zero.utilities.Vec2;
import openfl.display.Shader;

class OutlineShader extends Shader 
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

		void main(void) {
			vec4 sample = texture2D(bitmap, openfl_TextureCoordv);
			vec2 size = vec2(3.,3.);

			if (sample.a < 1.) {
				float w = size.x / openfl_TextureSize.x;
				float h = size.y / openfl_TextureSize.y;

				if (texture2D(bitmap, vec2(	openfl_TextureCoordv.x + w, 		openfl_TextureCoordv.y				)).a != 0.
				||	texture2D(bitmap, vec2(	openfl_TextureCoordv.x - w, 		openfl_TextureCoordv.y				)).a != 0.
				||	texture2D(bitmap, vec2(	openfl_TextureCoordv.x, 			openfl_TextureCoordv.y - h			)).a != 0.
				||	texture2D(bitmap, vec2(	openfl_TextureCoordv.x, 			openfl_TextureCoordv.y + h			)).a != 0.
				||	texture2D(bitmap, vec2(	openfl_TextureCoordv.x - w * 0.5, 	openfl_TextureCoordv.y - h * 0.5	)).a != 0.
				||	texture2D(bitmap, vec2(	openfl_TextureCoordv.x + w * 0.5, 	openfl_TextureCoordv.y - h * 0.5	)).a != 0.
				||	texture2D(bitmap, vec2(	openfl_TextureCoordv.x - w * 0.5, 	openfl_TextureCoordv.y + h * 0.5	)).a != 0.
				||	texture2D(bitmap, vec2(	openfl_TextureCoordv.x + w * 0.5, 	openfl_TextureCoordv.y + h * 0.5	)).a != 0.)
					sample += vec4(0., 0., 0., 1.);
			}

			gl_FragColor = sample;
		}
	")

	public function new() {
		super();
	}
	
}