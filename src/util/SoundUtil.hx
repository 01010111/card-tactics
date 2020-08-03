package util;

import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.Assets;
import openfl.media.Sound;

class SoundUtil {
	
	public static var sound_map:Map<Audio, {  sound: Sound, transform: SoundTransform, ?current:SoundChannel }> = [];

	public static function play(audio:Audio, volume:Float = 0.8, pan:Float = 0) {
		if (!sound_map.exists(audio)) sound_map.set(audio, { sound: Assets.getSound(cast audio), transform: new SoundTransform() });
		if (sound_map[audio].current != null) sound_map[audio].current.stop();
		sound_map[audio].transform.volume = volume;
		sound_map[audio].transform.pan = pan;
		sound_map[audio].current = sound_map[audio].sound.play(0, 0, sound_map[audio].transform);
	}

}

enum abstract Audio(String) {
	var TEST = 'audio/test.wav';
}