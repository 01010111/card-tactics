package ui;

import zero.utilities.Color;
import util.Translation;
import openfl.text.TextField;
import openfl.display.Sprite;
import data.Mutation;

class MutationSprite extends EquipmentSprite {

	public var mutation:Mutation;

	var one_shot_highlight:Sprite;

	public function new(mutation:Mutation) {
		super(mutation);
		this.mutation = mutation;
		draw();
	}

	function draw() {
		var back = new Sprite().load_graphic('images/ui/mutant_card.png', MIDDLE_CENTER, true).set_scale(0.25);
		this.add(back);

		var content = new Sprite().set_position(-EquipmentSprite.WIDTH/2, -EquipmentSprite.HEIGHT/2);
		this.add(content);

		var title = new TextField().format({ font: Translation.get_font(BOLD), size: 16, color: Color.BLACK }).set_string(Translation.get_equipment_title(mutation.data.id)).set_position(40, 42, MIDDLE_LEFT);
		content.add(title);

		var description = new TextField().format({ font: Translation.get_font(BOLD), size: 14, color: Color.BLACK, leading: -2, align: CENTER });
		description.set_string(Translation.get_mutant_description(mutation.data.id).wrap_string(description, 112)).set_position(EquipmentSprite.WIDTH/2, EquipmentSprite.HEIGHT/2 + 12, MIDDLE_CENTER);
		content.add(description);

		draw_classes(content);

		addChild(one_shot_highlight = new Sprite().rect(Color.PICO_8_WHITE, -EquipmentSprite.WIDTH/2 + 4, -EquipmentSprite.HEIGHT/2 + 4, EquipmentSprite.WIDTH - 8, EquipmentSprite.HEIGHT - 8, 16, 8));
		one_shot_highlight.alpha = 0;

		make_highlights();
		make_handle();
	}
	
}