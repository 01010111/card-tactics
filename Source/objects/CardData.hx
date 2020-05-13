package objects;

typedef CardData = {
	suit:CardSuit,
	value:CardValue,
}

typedef GearData = {
	name:String,
	desciption:String,
	value:Int,
	effects:Array<GearEffect>,
	?requirement: GearRequirement,
	?special:GearSpecial,
	?weakness:AttackType,
	?slots:SlotAmount,
}

typedef GearRequirement = {
	type:GearRequirementType,
	?value:Int,
	?boolean:Bool,
	?suit:CardSuit,
}

typedef GearEffect = {
	type:GearEffectType,
	?attack_type:AttackType,
	?value:Int,
	?range:Int,
	?repeat:Int,
	?steps:Int,
}

typedef GearSpecial = {
	requirement:GearRequirement,
	effect:SpecialEffect,
}

enum SlotAmount {
	ONE;
	TWO;
	THREE;
}

enum GearRequirementType {
	NONE;
	LESS_THAN;
	GREATER_THAN;
	EQUAL_TO;
	SUIT_IS;
	SUIT_NOT;
	IS_FACE;
}

enum GearEffectType {
	MOVEMENT;
	ATTACK;
	DEFENSE;
	UTILITY;
	DEFENSE_MOVEMENT;
	UTILITY_MOVEMENT;
	ATTACK_MOVEMENT;
}

enum SpecialEffect {
	ADD_ATTACK_TYPE_FLAME;
	ADD_ATTACK_TYPE_PIERCING;
	ADD_ATTACK_TYPE_BLUNT;
	ADD_DEFENCE_TYPE_FLAME;
	ADD_DEFENCE_TYPE_PIERCING;
	ADD_DEFENCE_TYPE_BLUNT;
	ADD_ONE_TO_VALUE;
	ADD_TWO_TO_VALUE;
	ADD_THREE_TO_VALUE;
	ADD_FOUR_TO_VALUE;
	ADD_FIVE_TO_VALUE;
	DOUBLE_VALUE;
	TRIPLE_VALUE;
	REUSE_GEAR;
	NOCLIP;
	SPREAD;
}

enum AttackType {
	FLAME;
	PIERCING;
	IMPACT;
	ELECTRIC;
}

enum CardType {
	GEAR;
	STANDARD;
}

enum CardSuit {
	HEARTS;
	DIAMONDS;
	SPADES;
	CLUBS;
}

enum CardValue {
	ACE;
	TWO;
	THREE;
	FOUR;
	FIVE;
	SIX;
	SEVEN;
	EIGHT;
	NINE;
	TEN;
	JACK;
	QUEEN;
	KING;
}