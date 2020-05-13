"use strict";
var App = /** @class */ (function () {
    function App() {
        App.i = this;
        this.preview = new PreviewCard();
        this.editor = new Editor();
        this.load_json();
    }
    App.init = function () { new App(); };
    App.prototype.load_json = function () {
        fetch('data/gear.json').then(function (res) { return res.json(); }).then(function (json) { return console.log(json); });
    };
    return App;
}());
var PreviewCard = /** @class */ (function () {
    function PreviewCard() {
        this.name = document.getElementById('preview-name');
        this.description = document.getElementById('preview-description');
        this.req_img_1 = document.getElementById('req-img-1');
        this.req_img_2 = document.getElementById('req-img-2');
        this.effect_img_1 = document.getElementById('effect-img-1');
        this.effect_img_2 = document.getElementById('effect-img-2');
        this.effect_img_3 = document.getElementById('effect-img-3');
        this.effect_img_4 = document.getElementById('effect-img-4');
        this.weakness_img = document.getElementById('weakness-img');
        this.name.innerText = 'Testy';
    }
    return PreviewCard;
}());
var Editor = /** @class */ (function () {
    function Editor() {
        var _this = this;
        this.name = document.getElementById('card-name');
        this.description = document.getElementById('card-description');
        this.value = document.getElementById('card-value');
        this.effect_type = document.getElementById('effect-type');
        this.attack_type = document.getElementById('effect-attack-type');
        this.effect_value = document.getElementById('effect-value');
        this.effect_range = document.getElementById('effect-range');
        this.effect_repeat = document.getElementById('effect-repeat');
        this.effect_steps = document.getElementById('effect-steps');
        this.effect_value_label = document.getElementById('effect-value-label');
        this.effect_range_label = document.getElementById('effect-range-label');
        this.effect_repeat_label = document.getElementById('effect-range-label');
        this.effect_steps_label = document.getElementById('effect-steps-label');
        this.req_type = document.getElementById('req-type');
        this.req_value = document.getElementById('req-value');
        this.req_suit = document.getElementById('req-suit');
        this.weakness = document.getElementById('card-weakness');
        this.name.oninput = function () {
            console.log('hey');
            App.i.preview.name.innerText = _this.name.value;
        };
        this.description.oninput = function () {
            App.i.preview.description.innerText = _this.description.value;
        };
        this.value.oninput = function () {
            console.log(_this.value.value);
        };
        this.effect_type.oninput = function () {
            var hide_el = [_this.attack_type, _this.effect_value, _this.effect_range, _this.effect_repeat, _this.effect_steps, _this.effect_range_label, _this.effect_repeat_label, _this.effect_steps_label, _this.effect_value_label];
            for (var _i = 0, hide_el_1 = hide_el; _i < hide_el_1.length; _i++) {
                var el = hide_el_1[_i];
                el.classList.add('hidden');
            }
            switch (_this.effect_type.value) {
                case "MOVEMENT":
                    _this.effect_steps.classList.remove('hidden');
                    _this.effect_steps_label.classList.remove('hidden');
                    break;
                case "ATTACK":
                    _this.attack_type.classList.remove('hidden');
                    _this.effect_value.classList.remove('hidden');
                    _this.effect_repeat.classList.remove('hidden');
                    _this.effect_value_label.classList.remove('hidden');
                    _this.effect_repeat_label.classList.remove('hidden');
                    break;
                case "DEFENSE":
                    _this.attack_type.classList.remove('hidden');
                    break;
                case "UTILITY":
                    _this.effect_value.classList.remove('hidden');
                    _this.effect_value_label.classList.remove('hidden');
                    break;
                case "ATTACK_MOVEMENT":
                    _this.attack_type.classList.remove('hidden');
                    _this.effect_value.classList.remove('hidden');
                    _this.effect_value_label.classList.remove('hidden');
                    _this.effect_steps.classList.remove('hidden');
                    _this.effect_steps_label.classList.remove('hidden');
                    break;
                case "DEFENSE_MOVEMENT":
                    _this.attack_type.classList.remove('hidden');
                    _this.effect_steps.classList.remove('hidden');
                    _this.effect_steps_label.classList.remove('hidden');
                    break;
                case "UTILITY_MOVEMENT":
                    _this.effect_value.classList.remove('hidden');
                    _this.effect_value_label.classList.remove('hidden');
                    _this.effect_steps.classList.remove('hidden');
                    _this.effect_steps_label.classList.remove('hidden');
                    break;
            }
            _this.process_effects();
        };
        this.req_type.oninput = function () {
            var req_el = [_this.req_value, _this.req_suit];
            for (var _i = 0, req_el_1 = req_el; _i < req_el_1.length; _i++) {
                var el = req_el_1[_i];
                el.classList.add('hidden');
            }
            switch (_this.req_type.value) {
                case "NONE":
                case "IS_FACE":
                    break;
                case "LESS_THAN":
                case "GREATER_THAN":
                case "EQUAL_TO":
                    _this.req_value.classList.remove('hidden');
                    break;
                case "SUIT_IS":
                case "SUIT_NOT":
                    _this.req_suit.classList.remove('hidden');
                    break;
            }
            _this.process_requirement();
        };
        this.req_type.oninput(new Event('poop'));
        this.req_value.oninput = function () { return _this.process_requirement(); };
        this.req_suit.oninput = function () { return _this.process_requirement(); };
        this.weakness.oninput = function () {
            App.i.preview.weakness_img.src = _this.get_damage_type_img(_this.weakness.value);
        };
    }
    Editor.prototype.process_requirement = function () {
        var preview = App.i.preview;
        var images = [];
        switch (this.req_type.value) {
            case "NONE": break;
            case "LESS_THAN":
                images = ['images/less_than.png', this.get_value_img(parseInt(this.req_value.value))];
                break;
            case "GREATER_THAN":
                images = ['images/greater_than.png', this.get_value_img(parseInt(this.req_value.value))];
                break;
            case "EQUAL_TO":
                images = ['images/equals.png', this.get_value_img(parseInt(this.req_value.value))];
                break;
            case "SUIT_IS": images = [this.get_suit_img(this.req_suit.value)];
            case "SUIT_NOT": images = [this.get_suit_img(this.req_suit.value, false)];
        }
        preview.req_img_1.src = images[0] || 'images/empty.png';
        preview.req_img_2.src = images[1] || 'images/empty.png';
    };
    Editor.prototype.process_effects = function () {
        var preview = App.i.preview;
        var images = [];
        preview.effect_img_1.src = images[0] || 'images/empty.png';
        preview.effect_img_2.src = images[1] || 'images/empty.png';
        preview.effect_img_3.src = images[2] || 'images/empty.png';
        preview.effect_img_4.src = images[3] || 'images/empty.png';
    };
    Editor.prototype.get_value_img = function (value) {
        value = Math.min(Math.max(value, 1), 10);
        if (value == 1)
            return 'images/A.png';
        return "images/" + value + ".png";
    };
    Editor.prototype.get_suit_img = function (suit, suit_is) {
        if (suit_is === void 0) { suit_is = true; }
        suit = suit.toLowerCase().substr(0, suit.length - 1);
        return suit_is ? "images/" + suit + ".png" : "images/not_" + suit + ".png";
    };
    Editor.prototype.get_damage_type_img = function (type) {
        return "images/" + type.toLowerCase() + ".png";
    };
    return Editor;
}());
