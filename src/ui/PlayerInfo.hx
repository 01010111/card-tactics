package ui;

import util.Translation;
import zero.utilities.Ease;
import zero.utilities.Tween;
import filters.OutlineShader;
import openfl.filters.ShaderFilter;
import openfl.text.TextField;
import zero.openfl.utilities.Game;
import zero.utilities.Color;
import openfl.events.MouseEvent;
import objects.Player;
import openfl.display.Sprite;

using zero.openfl.extensions.SpriteTools;
using zero.openfl.extensions.TextTools;
using zero.extensions.Tools;
using Math;

class PlayerInfo extends Sprite {

	var player:Player;
	var avatar:Sprite;
	var health:Sprite;
	var ap_pts:Sprite;
	var shield:Sprite;
	var health_text:TextField;
	var health_text_sprite:Sprite;
	var ap_pts_text:TextField;
	var shield_text:TextField;

	public function new(player:Player, side:PlayerSide) {
		super();
		this.player = player;
		make_avatar();
		make_ap_pts();
		make_health();
		make_shield();
		this.set_position(side == LEFT ? 72 : Game.width - 72, 80);
	}
	
	function make_avatar() {
		avatar = new Sprite();
		avatar.fill_circle(Color.PICO_8_ORANGE, 0, 0, 48);
		avatar.addEventListener(MouseEvent.MOUSE_DOWN, on_click);
		this.add(avatar);
	}

	function make_ap_pts() {
		ap_pts = new Sprite().set_position(0, 80);
		ap_pts_text = new TextField().format({ font: Translation.get_font(BOLD), color: Color.PICO_8_WHITE, size: 24 });

		ap_pts.fill_rect(Color.PICO_8_DARK_BLUE, -48, -16, 96, 32, 32);
		ap_pts.add(new Sprite().load_graphic('images/ui/ap_pips.png', MIDDLE_CENTER, true).set_position(-26, 0));

		this.add(ap_pts);
		ap_pts.add(ap_pts_text);

		update_ap_pts();
	}

	function make_health() {
		health = new Sprite().set_position(0, 116);
		health_text_sprite = new Sprite();
		health_text = new TextField().format({ font: Translation.get_font(BOLD), color: Color.PICO_8_WHITE, size: 24 });
		var filter = new ShaderFilter(new OutlineShader());
		filter.topExtension = filter.bottomExtension = filter.leftExtension = filter.rightExtension = 64;
		health_text_sprite.filters = [filter];

		this.add(health);
		health_text_sprite.add(health_text);
		health.add(health_text_sprite);

		update_health();
	}

	function make_shield() {
		shield = new Sprite().set_position(28, 124).set_scale(0);
		var shield_sprite = new Sprite().load_graphic('images/ui/shield_icon.png', MIDDLE_CENTER, true);
		shield.add(shield_sprite);
		var shield_text_sprite = new Sprite();
		shield_text = new TextField().format({ font: Translation.get_font(BOLD), color: Color.BLACK, size: 14 });
		shield_text_sprite.add(shield_text);
		var filter = new ShaderFilter(new OutlineShader());
		filter.topExtension = filter.bottomExtension = filter.leftExtension = filter.rightExtension = 16;
		health_text_sprite.filters = [filter];

		this.add(shield);
		shield.add(shield_text_sprite);
	}

	public function update_ap_pts() {
		ap_pts_text.set_string('${player.AP}').set_position(0, 0, MIDDLE_CENTER);
	}

	public function update_health() {
		health_text.set_string('${player.health.current.floor()}').set_position(0, 0, MIDDLE_CENTER);
		health.graphics.clear();
		health
			.fill_rect(Color.BLACK, -48, -16, 96, 32, 32)
			.fill_rect(Color.PICO_8_WHITE, -44, -12, 88, 24, 28)
			.fill_rect(Color.PICO_8_DARK_BLUE, -40, -8, 80, 16, 16);
		if (player.health.current > 0) health.fill_rect(Color.PICO_8_RED, -40, -8, ((player.health.current/player.health.max) * 80).max(16), 16, 16);

		Tween.get(health_text_sprite).from_to('scaleX', 1.5, 1).from_to('scaleY', 1.5, 1).from_to('rotation', 45.get_random(-45), 0).ease(Ease.elasticOut);
	}

	public function update_shield() {
		var from = shield.scaleX;
		var to = player.shield == 0 ? 0 : 1;
		shield_text.set_string('${player.shield}').set_position(0, -2, MIDDLE_CENTER);
		Tween.get(shield).from_to('scaleX', from, to).from_to('scaleY', from, to).duration(0.5).ease(Ease.backOut);
	}

	function on_click(e:MouseEvent) {
		Player.selected_player = player;
	}

}