package particles;

import scenes.Level;
import zero.utilities.Ease;
import zero.openfl.utilities.AnimatedSprite;
import zero.openfl.utilities.Particles.Particle;

class Poof extends AnimatedSprite implements Particle {

    var available:Bool = true;

    public function new() {
        super({
            source: 'images/particles/poof.png',
            frame_width: 16,
            frame_height: 16,
            offset_x: 8,
            offset_y: 8,
            animations: [
                { name: '0', frames: [0,1,2,3,4,5,6,7], ease: Ease.quadOut, duration: 0.5, type: SINGLE_SHOT_FORWARDS, on_complete: complete },
                { name: '1', frames: [8,9,10,11,12,13,14,15], ease: Ease.quadOut, duration: 0.5, type: SINGLE_SHOT_FORWARDS, on_complete: complete },
            ]
        });
        alpha = 0;
        Level.i.under_objects.add(this);
    }

    function complete() {
        available = true;
        alpha = 0;
        x = -128;
        y = -128;
    }

    public function fire(options:Dynamic) {
        available = false;
        alpha = 1;
        this.set_position(options.x, options.y);
        animation.play(['0', '1'].get_random(), 0.25.get_random(), true);
        rotation = Std.int(4.get_random()) * 90;
    }

    public function get_available():Bool {
        return available;
    }

}