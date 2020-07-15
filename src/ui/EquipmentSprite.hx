package ui;

import objects.Player;
import openfl.events.MouseEvent;
import openfl.display.Sprite;

class EquipmentSprite extends DropSprite {

	public static final WIDTH:Float = 192;
	public static final HEIGHT:Float = 224;

	public var equipment:data.Equipment;
	public var handle:EquipmentHandle;

	public function new(equipment:data.Equipment) {
		super();
		this.equipment = equipment;
		equipment.sprite = this;
		expendable = equipment;
		draggable = false;
		data = {
			requirement: equipment.data.requirement,
			requirement_value: equipment.data.requirement_value
		};
		addEventListener(MouseEvent.MOUSE_OVER, mouse_over);
		addEventListener(MouseEvent.MOUSE_OUT, mouse_out);
	}

	function mouse_over(e:MouseEvent) if (!expended || active) LEVEL.draw_indicators(equipment, Player.selected_player);
	function mouse_out(e:MouseEvent) if (!active) LEVEL.clear_indicators();

	function draw_classes(sprite:Sprite) {
		var class_src = switch equipment.data.equipment_class {
			default: 'images/blank.png';
			case FLAME:'images/ui/icons/on_white/icon_flame.png';
			case PIERCING:'images/ui/icons/on_white/icon_pierce.png';
			case EXPLOSIVE:'images/ui/icons/on_white/icon_explode.png';
			case ELECTRICITY:'images/ui/icons/on_white/icon_electrify.png';
			case WATER:'images/ui/icons/on_white/icon_water.png';
			case SHIELD:'images/ui/icons/on_white/icon_shield.png';
			case MOVE:'images/ui/icons/on_white/icon_move.png';
			case HEALTH:'images/ui/icons/on_white/icon_health.png';
			case UTILITY:'images/ui/icons/on_white/icon_utility.png';
		}
		var weakness_src = switch equipment.data.weakness {
			default: 'images/blank.png';
			case FLAME:'images/ui/icons/on_white/icon_flame.png';
			case PIERCING:'images/ui/icons/on_white/icon_pierce.png';
			case EXPLOSIVE:'images/ui/icons/on_white/icon_explode.png';
			case ELECTRICITY:'images/ui/icons/on_white/icon_electrify.png';
			case WATER:'images/ui/icons/on_white/icon_water.png';
			case SHIELD:'images/ui/icons/on_white/icon_shield.png';
			case MOVE:'images/ui/icons/on_white/icon_move.png';
			case HEALTH:'images/ui/icons/on_white/icon_health.png';
			case UTILITY:'images/ui/icons/on_white/icon_utility.png';
		}
		sprite.addChild(new Sprite().load_graphic(class_src, TOP_LEFT, true).set_position(16, 196).set_scale(0.25));
		sprite.addChild(new Sprite().load_graphic(weakness_src, TOP_LEFT, true).set_position(160, 196).set_scale(0.25));
		sprite.addChild(new Sprite().load_graphic('images/ui/icons/icon_skull.png', TOP_LEFT, true).set_position(144, 180).set_scale(0.25));
	}

	function make_handle() {
		handle = new EquipmentHandle(equipment.data.range.max == 0 ? PRESS : AIM, this);
	}

	public function get_effect_string() {
		var val = equipment.get_effect_value();
		return val == 0 ? '_' : '$val';
	}

	override function add_card(card:PlayingCard) {
		super.add_card(card);
		equipment.add_card(card.data);
		redraw();
	}

	override function remove_card(card:PlayingCard) {
		super.remove_card(card);
		equipment.remove_card(card.data);
		redraw();
	}

	function redraw() {}

}