class_name Generator


static var categoryProbs: Dictionary[Category, float] = {}


static func reset() -> void:
	for cat: Category in Category.values():
		categoryProbs.put( cat, cat.prob );



static func random() -> Item:
	return random( Random.chances( categoryProbs ) );


static func random_cat(cat: Category) -> Item:
	categoryProbs.put( cat, categoryProbs.get( cat ) / 2 );

	match (cat):
		ARMOR:
			return randomArmor();
		WEAPON:
			return randomWeapon();
		_:
			return (cat.classes[Random.chances( cat.probs )].newInstance() as Item).random();



static func random_cl(cl) -> Item:
	return (cl.newInstance() as Item).random();

static func randomArmor() -> Armor:

	var curStr: int = Hero.STARTING_STR + Dungeon.potionOfStrength;

	var cat: Category = Category.ARMOR;

	var a1: Armor = cat.classes[Random.chances( cat.probs )].newInstance() as Armor
	var a2: Armor = cat.classes[Random.chances( cat.probs )].newInstance() as Armor

	a1.random();
	a2.random();

	return a1 if abs( curStr - a1.STR ) < abs( curStr - a2.STR ) else a2


static func randomWeapon() -> Weapon:

	var curStr: int = Hero.STARTING_STR + Dungeon.potionOfStrength;

	var cat: Category = Category.WEAPON;

	var w1: Weapon = cat.classes[Random.chances( cat.probs )].newInstance() as Weapon
	var w2: Weapon = cat.classes[Random.chances( cat.probs )].newInstance() as Weapon

	w1.random();
	w2.random();

	return w1 if abs( curStr - w1.STR ) < abs( curStr - w2.STR ) else w2;
