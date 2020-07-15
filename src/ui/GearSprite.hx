package ui;

import openfl.geom.Point;
import openfl.events.MouseEvent;
import openfl.events.Event;
import zero.utilities.Vec2;
import openfl.text.TextFormatAlign;
import openfl.text.TextField;
import openfl.display.Sprite;
import zero.utilities.Color;
import data.Gear;

using util.Translation;
using util.CardUtil;

class GearSprite extends EquipmentSprite {
	
	public static var PLACEABLE_GEAR:GearSprite;

	public var gear:Gear;
	public var home:Vec2;

	var description:TextField;
	var req_text:TextField;
	var req_text_r:TextField;
	var destroy_button:Sprite;

	public function new(gear:Gear) {
		super(gear);
		this.gear = gear;
		this.gear.sprite = this;
		anchors = [[-35, 28], [35, 28]];
		draw();
	}

	function draw() {
		// Back
		{
			this.fill_rect(Color.get().from_int32(0xFF7CB11F), -EquipmentSprite.WIDTH/2, -EquipmentSprite.HEIGHT/2, EquipmentSprite.WIDTH, EquipmentSprite.HEIGHT, 16);
			this.rect(Color.BLACK, -EquipmentSprite.WIDTH/2 + 2, -EquipmentSprite.HEIGHT/2 + 2, EquipmentSprite.WIDTH - 4, EquipmentSprite.HEIGHT - 4, 12, 4);
		}
		
		// Contents
		{
			var contents = new Sprite();
			contents.set_position(-EquipmentSprite.WIDTH/2, -EquipmentSprite.HEIGHT/2);
			this.add(contents);

			// AP cost
			{
				for (i in 0...gear.gear_data.cost) {
					var pip = new Sprite().load_graphic('images/ui/ap_pip.png', TOP_LEFT, true).set_position(165 - i * 11, 10);
					pip.add_info('gear_ap');
					contents.add(pip);
				}
			}

			// Title
			{
				contents.add(new Sprite().fill_rect(Color.PICO_8_WHITE, 26, 28, 140, 24, 24));
				var title = new TextField().format({ font: Translation.get_font(BOLD), size: 16, color: Color.BLACK }).set_string(Translation.get_equipment_title(gear.gear_data.id)).set_position(40, 38, MIDDLE_LEFT);
				contents.add(title);
			}

			// Description
			{
				description = new TextField().format({ font: Translation.get_font(BOLD), size: 14, color: Color.BLACK, leading: -2 });
				contents.add(description);
				set_description();
			}
		
			// Drop box
			{
				contents.add(new Sprite().fill_rect(Color.PICO_8_DARK_GREEN, 16, 92, 160, 96, 16));

				req_text = new TextField().format({ font: Translation.get_font(BOLD), size: 20, color: Color.PICO_8_DARK_BLUE });
				contents.add(req_text);
				set_req_text();

				req_text_r = new TextField().format({ font: Translation.get_font(BOLD), size: 16, color: Color.PICO_8_DARK_BLUE, align: TextFormatAlign.CENTER });
				contents.add(req_text_r);
				set_req_text_r();
			}

			// Bonus
			{
				var src = switch gear.gear_data.bonus.requirement {
					case IS_FACE:'images/ui/rule_face.png';
					case TWO_CARDS:'images/ui/rule_two_cards.png';
					case HEARTS:'images/ui/suit_heart.png';
					case DIAMONDS:'images/ui/suit_diamond.png';
					case CLUBS:'images/ui/suit_club.png';
					case SPADES:'images/ui/suit_spade.png';
					default: 'images/blank.png';
				}
				contents.add(new Sprite().load_graphic(src, MIDDLE_CENTER, true).set_position(20, 92).set_scale(0.125));
			}

			draw_classes(contents);
		}

		make_highlights();
		make_handle();
		make_destroy_button();
	}

	function make_destroy_button() {
		destroy_button = new Sprite().fill_rect(Color.PICO_8_RED, -48, -24, 96, 48, 48).rect(Color.BLACK, -48, -24, 96, 48, 48, 4).set_position(0, EquipmentSprite.HEIGHT/2).set_scale(0);
		destroy_button.add(new TextField().format({ font: Translation.get_font(BOLD), size: 14, color: Color.WHITE }).set_string('DESTROY').set_position(0, 0, MIDDLE_CENTER));
		destroy_button.buttonMode = true;
		destroy_button.addEventListener(MouseEvent.CLICK, (e) -> destroy());
		this.add(destroy_button);
	}

	function set_description() {
		var str = switch gear.gear_data.effect.type {
			case DAMAGE: 'gear_desc_damage'.get_gameplay_text().replace(get_effect_string());
			case MOVE: 'gear_desc_move'.get_gameplay_text().replace(get_effect_string());
			case SHIELD: 'gear_desc_shield'.get_gameplay_text().replace(get_effect_string());
			case HEALTH: 'gear_desc_health'.get_gameplay_text().replace(get_effect_string());
			case DRAW: 'gear_desc_draw'.get_gameplay_text().replace(get_effect_string());
		}
		description.set_string(str.wrap_string(description, 128)).set_position(EquipmentSprite.WIDTH/2, 70, MIDDLE_CENTER);
	}

	function set_req_text() {
		if (cards.length > 0) {
			req_text.set_string('');
			return;
		}
		var str = switch gear.gear_data.requirement {
			default: '';
			case MIN_TOTAL:'gear_req_min_total'.get_gameplay_text().replace('${gear.gear_data.requirement_value - 1}');
			case MAX_TOTAL:'gear_req_max_total'.get_gameplay_text().replace('${gear.gear_data.requirement_value + 1}');
			case MIN_CARD:'gear_req_min_card'.get_gameplay_text().replace('${gear.gear_data.requirement_value - 1}');
			case MAX_CARD:'gear_req_max_card'.get_gameplay_text().replace('${gear.gear_data.requirement_value + 1}');
			case EXACT_CARD:'gear_req_exact_card'.get_gameplay_text().replace('${gear.gear_data.requirement_value}');
			case EXACT_TOTAL:'gear_req_exact_total'.get_gameplay_text().replace('${gear.gear_data.requirement_value}');
			case IS_FACE:'gear_req_face'.get_gameplay_text();
			case NOT_FACE:'gear_req_not_face'.get_gameplay_text();
			case PAIR:'gear_req_pair'.get_gameplay_text();
			case NO_MATCH:'gear_req_no_match'.get_gameplay_text();
			case SAME_SUIT:'gear_req_same_suit'.get_gameplay_text();
			case DIFF_SUIT:'gear_req_diff_suit'.get_gameplay_text();
			case HEARTS:'gear_req_hearts'.get_gameplay_text();
			case DIAMONDS:'gear_req_diamonds'.get_gameplay_text();
			case CLUBS:'gear_req_clubs'.get_gameplay_text();
			case SPADES:'gear_req_spades'.get_gameplay_text();
			case TWO_CARDS:'gear_req_two_cards'.get_gameplay_text();
		}
		req_text.set_string(str).set_position(EquipmentSprite.WIDTH/2, 140, MIDDLE_CENTER);
	}

	function set_req_text_r() {
		if (cards.length == 0 || cards.length == 2) {
			req_text_r.set_string('');
			return;
		}
		var str = switch gear.gear_data.requirement {
			default: '';
			case MIN_TOTAL:'gear_req_sm_min_total'.get_gameplay_text().replace('${(gear.gear_data.requirement_value - 1 - cards[0].data.value.value_to_int()).max(0)}');
			case MAX_TOTAL:'gear_req_sm_max_total'.get_gameplay_text().replace('${gear.gear_data.requirement_value + 1 - cards[0].data.value.value_to_int()}');
			case MIN_CARD:'gear_req_sm_min_card'.get_gameplay_text().replace('${gear.gear_data.requirement_value - 1}');
			case MAX_CARD:'gear_req_sm_max_card'.get_gameplay_text().replace('${gear.gear_data.requirement_value + 1}');
			case EXACT_CARD:'gear_req_sm_exact_card'.get_gameplay_text().replace('${gear.gear_data.requirement_value}');
			case EXACT_TOTAL:'gear_req_sm_exact_total'.get_gameplay_text().replace('${gear.gear_data.requirement_value - cards[0].data.value.value_to_int()}');
			case IS_FACE:'gear_req_sm_face'.get_gameplay_text();
			case NOT_FACE:'gear_req_sm_not_face'.get_gameplay_text().split(' ').join('\n');
			case PAIR:'gear_req_sm_pair'.get_gameplay_text().replace('${cards[0].data.value.value_to_string()}');
			case NO_MATCH:'gear_req_sm_no_match'.get_gameplay_text().replace('\n${cards[0].data.value.value_to_string()}');
			case SAME_SUIT:'gear_req_sm_same_suit'.get_gameplay_text().replace('${cards[0].data.suit.suit_to_string()}');
			case DIFF_SUIT:'gear_req_sm_diff_suit'.get_gameplay_text().replace('\n${cards[0].data.suit.suit_to_string()}');
			case HEARTS:'gear_req_sm_hearts'.get_gameplay_text();
			case DIAMONDS:'gear_req_sm_diamonds'.get_gameplay_text();
			case CLUBS:'gear_req_sm_clubs'.get_gameplay_text();
			case SPADES:'gear_req_sm_spades'.get_gameplay_text();
			case TWO_CARDS:'gear_req_sm_two_cards'.get_gameplay_text();
		}
		req_text_r.set_string(str).set_position(EquipmentSprite.WIDTH/2 + 36, 140, MIDDLE_CENTER);
	}

	override function redraw() {
		set_description();
		set_req_text();
		set_req_text_r();
	}

	override function update(e:Event) {
		super.update(e);
		if (draggable && !dragging && home != null) {
			x += (home.x - x) * 0.25;
			y += (home.y - y) * 0.25;
		}
		var destroy_scale = switch GAMESTATE {
			case PLACING_GEAR: expended || active ? 0 : 1;
			default: 0;
		}
		destroy_button.scaleY = destroy_button.scaleX += (destroy_scale - destroy_button.scaleX) * 0.25;
	}

	override function mouse_up(e:MouseEvent) {
		super.mouse_up(e);
		if (PLACEABLE_GEAR == this) {
			for (spot in InventorySprite.active_inventory.placeholder_sprites) if (spot.visible) {
				var pos = spot.parent.localToGlobal(new Point(spot.x, spot.y));
				var v1:Vec2 = [pos.x, pos.y];
				var v2:Vec2 = [x, y];
				var d = v1 - v2;
				if(d.length < 64) {
					if (!insert_into_inventory(spot.position, InventorySprite.active_inventory)) return;
					this.set_position(spot.x + d.x, spot.y + d.y);
					GAMESTATE = USING_GEAR;
				}
				v1.put();
				v2.put();
				d.put();
			}
		}
	}
	
	function insert_into_inventory(position:Int, inventory:InventorySprite):Bool {
		if (inventory.inventory.owner.AP < gear.gear_data.cost) return false;
		draggable = false;
		gear.position = position;
		inventory.add_equipment(this);
		PLACEABLE_GEAR = null;
		active = false;
		return true;
	}

	function destroy() {
		equipment.inventory.owner.AP += gear.gear_data.cost;
		equipment.inventory.sprite.remove_equipment(this);
		this.remove();
	}

}