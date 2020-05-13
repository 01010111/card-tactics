class App {
	static init() { new App(); }
	static i:App;
	preview:PreviewCard;
	editor:Editor;
	constructor() {
		App.i = this;
		this.preview = new PreviewCard();
		this.editor = new Editor();
		this.load_json();
	}
	load_json() {
		fetch('data/gear.json').then((res) => res.json()).then((json) => console.log(json));
	}
}

class PreviewCard {
	name:HTMLDivElement;
	description:HTMLDivElement;
	req_img_1:HTMLImageElement;
	req_img_2:HTMLImageElement;
	effect_img_1:HTMLImageElement;
	effect_img_2:HTMLImageElement;
	effect_img_3:HTMLImageElement;
	effect_img_4:HTMLImageElement;
	weakness_img:HTMLImageElement;
	constructor() {
		this.name = document.getElementById('preview-name') as HTMLDivElement;
		this.description = document.getElementById('preview-description') as HTMLDivElement;
		this.req_img_1 = document.getElementById('req-img-1') as HTMLImageElement;
		this.req_img_2 = document.getElementById('req-img-2') as HTMLImageElement;
		this.effect_img_1 = document.getElementById('effect-img-1') as HTMLImageElement;
		this.effect_img_2 = document.getElementById('effect-img-2') as HTMLImageElement;
		this.effect_img_3 = document.getElementById('effect-img-3') as HTMLImageElement;
		this.effect_img_4 = document.getElementById('effect-img-4') as HTMLImageElement;
		this.weakness_img = document.getElementById('weakness-img') as HTMLImageElement;
		this.name.innerText = 'Testy';
	}
}

class Editor {
	name:HTMLInputElement;
	description:HTMLTextAreaElement;
	value:HTMLInputElement;
	effect_type:HTMLSelectElement;
	attack_type:HTMLSelectElement;
	effect_value:HTMLInputElement;
	effect_range:HTMLInputElement;
	effect_repeat:HTMLInputElement;
	effect_steps:HTMLInputElement;
	effect_value_label:HTMLLabelElement;
	effect_range_label:HTMLLabelElement;
	effect_repeat_label:HTMLLabelElement;
	effect_steps_label:HTMLLabelElement;
	req_type:HTMLSelectElement;
	req_value:HTMLInputElement;
	req_suit:HTMLSelectElement;
	weakness:HTMLSelectElement;
	constructor() {
		this.name = document.getElementById('card-name') as HTMLInputElement;
		this.description = document.getElementById('card-description') as HTMLTextAreaElement;
		this.value = document.getElementById('card-value') as HTMLInputElement;
		this.effect_type = document.getElementById('effect-type') as HTMLSelectElement;
		this.attack_type = document.getElementById('effect-attack-type') as HTMLSelectElement;
		this.effect_value = document.getElementById('effect-value') as HTMLInputElement;
		this.effect_range = document.getElementById('effect-range') as HTMLInputElement;
		this.effect_repeat = document.getElementById('effect-repeat') as HTMLInputElement;
		this.effect_steps = document.getElementById('effect-steps') as HTMLInputElement;
		this.effect_value_label = document.getElementById('effect-value-label') as HTMLLabelElement;
		this.effect_range_label = document.getElementById('effect-range-label') as HTMLLabelElement;
		this.effect_repeat_label = document.getElementById('effect-range-label') as HTMLLabelElement;
		this.effect_steps_label = document.getElementById('effect-steps-label') as HTMLLabelElement;
		this.req_type = document.getElementById('req-type') as HTMLSelectElement;
		this.req_value = document.getElementById('req-value') as HTMLInputElement;
		this.req_suit = document.getElementById('req-suit') as HTMLSelectElement;
		this.weakness = document.getElementById('card-weakness') as HTMLSelectElement;
		this.name.oninput = () => {
			console.log('hey');
			App.i.preview.name.innerText = this.name.value;
		}
		this.description.oninput = () => {
			App.i.preview.description.innerText = this.description.value;
		}
		this.value.oninput = () => {
			console.log(this.value.value);
		}
		this.effect_type.oninput = () => {
			var hide_el = [this.attack_type, this.effect_value, this.effect_range, this.effect_repeat, this.effect_steps, this.effect_range_label, this.effect_repeat_label, this.effect_steps_label, this.effect_value_label];
			for (let el of hide_el) el.classList.add('hidden');
			switch (this.effect_type.value) {
				case "MOVEMENT":
					this.effect_steps.classList.remove('hidden');
					this.effect_steps_label.classList.remove('hidden');
					break;
				case "ATTACK":
					this.attack_type.classList.remove('hidden');
					this.effect_value.classList.remove('hidden');
					this.effect_repeat.classList.remove('hidden');
					this.effect_value_label.classList.remove('hidden');
					this.effect_repeat_label.classList.remove('hidden');
					break;
				case "DEFENSE":
					this.attack_type.classList.remove('hidden');
					break;
				case "UTILITY":
					this.effect_value.classList.remove('hidden');
					this.effect_value_label.classList.remove('hidden');
					break;
				case "ATTACK_MOVEMENT":
					this.attack_type.classList.remove('hidden');
					this.effect_value.classList.remove('hidden');
					this.effect_value_label.classList.remove('hidden');
					this.effect_steps.classList.remove('hidden');
					this.effect_steps_label.classList.remove('hidden');
					break;
				case "DEFENSE_MOVEMENT":
					this.attack_type.classList.remove('hidden');
					this.effect_steps.classList.remove('hidden');
					this.effect_steps_label.classList.remove('hidden');
					break;
				case "UTILITY_MOVEMENT":
					this.effect_value.classList.remove('hidden');
					this.effect_value_label.classList.remove('hidden');
					this.effect_steps.classList.remove('hidden');
					this.effect_steps_label.classList.remove('hidden');
					break;
			}
			this.process_effects();
		}
		this.req_type.oninput = () => {
			var req_el = [this.req_value, this.req_suit];
			for (let el of req_el) el.classList.add('hidden');
			switch (this.req_type.value) {
				case "NONE":
				case "IS_FACE":
					break;
				case "LESS_THAN":
				case "GREATER_THAN":
				case "EQUAL_TO":
					this.req_value.classList.remove('hidden');
					break;
				case "SUIT_IS":
				case "SUIT_NOT":
					this.req_suit.classList.remove('hidden');
					break;
			}
			this.process_requirement();
		}
		this.req_type.oninput(new Event('poop'));
		this.req_value.oninput = () => this.process_requirement();
		this.req_suit.oninput = () => this.process_requirement();
		this.weakness.oninput = () => {
			App.i.preview.weakness_img.src = this.get_damage_type_img(this.weakness.value);
		}
	}
	process_requirement() {
		let preview = App.i.preview;
		let images:string[] = [];
		switch (this.req_type.value) {
			case "NONE": break;
			case "LESS_THAN": images = ['images/less_than.png', this.get_value_img(parseInt(this.req_value.value))]; break;
			case "GREATER_THAN": images = ['images/greater_than.png', this.get_value_img(parseInt(this.req_value.value))]; break;
			case "EQUAL_TO": images = ['images/equals.png', this.get_value_img(parseInt(this.req_value.value))]; break;
			case "SUIT_IS": images = [this.get_suit_img(this.req_suit.value)];
			case "SUIT_NOT": images = [this.get_suit_img(this.req_suit.value, false)];
		}
		preview.req_img_1.src = images[0] || 'images/empty.png';
		preview.req_img_2.src = images[1] || 'images/empty.png';
	}
	process_effects() {
		let preview = App.i.preview;
		let images:string[] = [];
		
		preview.effect_img_1.src = images[0] || 'images/empty.png';
		preview.effect_img_2.src = images[1] || 'images/empty.png';
		preview.effect_img_3.src = images[2] || 'images/empty.png';
		preview.effect_img_4.src = images[3] || 'images/empty.png';
	}
	get_value_img(value:number) {
		value = Math.min(Math.max(value, 1), 10);
		if (value == 1) return 'images/A.png';
		return `images/${value}.png`;
	}
	get_suit_img(suit:string, suit_is:boolean = true) {
		suit = suit.toLowerCase().substr(0, suit.length - 1);
		return suit_is ? `images/${suit}.png` : `images/not_${suit}.png`;
	}
	get_damage_type_img(type:string) {
		return `images/${type.toLowerCase()}.png`;
	}
}