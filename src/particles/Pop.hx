package particles;

import scenes.Level;
import zero.utilities.Ease;
import zero.openfl.utilities.AnimatedSprite;
import zero.openfl.utilities.Particles.Particle;

class Pop extends AnimatedSprite implements Particle {

    var available:Bool = true;

    public function new() {
        super({
            source: 'images/particles/pop.png',
            frame_width: 32,
            frame_height: 32,
            offset_x: 16,
            offset_y: 16,
            animations: [{ name: '0', frames: [0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8], ease: Ease.quadOut, duration: 0.25, type: SINGLE_SHOT_FORWARDS, on_complete: complete }]
        });
        alpha = 0;
        LEVEL.over_objects.add(this);
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
        animation.play('0', true);
        rotation = Std.int(4.get_random()) * 90;
    }

    public function get_available():Bool {
        return available;
    }

}