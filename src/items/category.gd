class_name Category
extends Resource

enum CategoryType {
	Weapon,
	Armor,
	Potion,
	Scroll,
	Wand,
	Ring,
	Seed,
	Food,
	Gold,
	Misc
}

#static var types: Dictionary[CategoryType, Category] = {
	#CategoryType.Weapon: Category.new(15, Weapon.class),
	#CategoryType.Armor: Category.new(10, Armor.class),
	#CategoryType.Potion: Category.new(50, Potion.class),
	#CategoryType.Scroll: Category.new(40, Scroll.class),
	#CategoryType.Wand: Category.new	(4, Wand.class),
	#CategoryType.Ring: Category.new	(2, Ring.class),
	#CategoryType.Seed: Category.new	(5, Plant.Seed.class),
	#CategoryType.Food: Category.new	(0, Food.class),
	#CategoryType.Gold: Category.new	(50, Gold.class),
	#CategoryType.Misc: Category.new	(5, Item.class)
#}

@export var classes: PackedStringArray
@export var probs: PackedFloat32Array

@export var prob: float
@export var superClass: String

func _init(prob: float, superClass: String) -> void:
	self.prob = prob;
	self.superClass = superClass;


static func order(item: Item) -> int:
	for i: int in range(Globals.cat_types.length):
		if (Globals.cat_types[i].superClass.isInstance( item )):
			return i;


	var MaxInt: int = 9223372036854775807
	return MaxInt if item is Bag else MaxInt - 1



#
#
#static {
#
	#Category.GOLD.classes = new Class<?>[]{
		#Gold.class };
	#Category.GOLD.probs = new float[]{ 1 };
#
	#Category.SCROLL.classes = new Class<?>[]{
		#ScrollOfIdentify.class,
		#ScrollOfTeleportation.class,
		#ScrollOfRemoveCurse.class,
		#ScrollOfRecharging.class,
		#ScrollOfMagicMapping.class,
		#ScrollOfChallenge.class,
		#ScrollOfTerror.class,
		#ScrollOfLullaby.class,
		#ScrollOfPsionicBlast.class,
		#ScrollOfMirrorImage.class,
		#ScrollOfUpgrade.class,
		#ScrollOfEnchantment.class };
	#Category.SCROLL.probs = new float[]{ 30, 10, 15, 10, 15, 12, 8, 8, 4, 6, 0, 1 };
#
	#Category.POTION.classes = new Class<?>[]{
		#PotionOfHealing.class,
		#PotionOfExperience.class,
		#PotionOfToxicGas.class,
		#PotionOfParalyticGas.class,
		#PotionOfLiquidFlame.class,
		#PotionOfLevitation.class,
		#PotionOfStrength.class,
		#PotionOfMindVision.class,
		#PotionOfPurity.class,
		#PotionOfInvisibility.class,
		#PotionOfMight.class,
		#PotionOfFrost.class };
	#Category.POTION.probs = new float[]{ 45, 4, 15, 10, 15, 10, 0, 20, 12, 10, 0, 10 };
#
	#Category.WAND.classes = new Class<?>[]{
		#WandOfTeleportation.class,
		#WandOfSlowness.class,
		#WandOfFirebolt.class,
		#WandOfRegrowth.class,
		#WandOfPoison.class,
		#WandOfBlink.class,
		#WandOfLightning.class,
		#WandOfAmok.class,
		#WandOfReach.class,
		#WandOfFlock.class,
		#WandOfMagicMissile.class,
		#WandOfDisintegration.class,
		#WandOfAvalanche.class };
	#Category.WAND.probs = new float[]{ 10, 10, 15, 6, 10, 11, 15, 10, 6, 10, 0, 5, 5 };
#
	#Category.WEAPON.classes = new Class<?>[]{
		#Dagger.class,
		#Knuckles.class,
		#Quarterstaff.class,
		#Spear.class,
		#Mace.class,
		#Sword.class,
		#Longsword.class,
		#BattleAxe.class,
		#WarHammer.class,
		#Glaive.class,
		#ShortSword.class,
		#Dart.class,
		#Javelin.class,
		#IncendiaryDart.class,
		#CurareDart.class,
		#Shuriken.class,
		#Boomerang.class,
		#Tamahawk.class };
	#Category.WEAPON.probs = new float[]{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 1 };
#
	#Category.ARMOR.classes = new Class<?>[]{
		#ClothArmor.class,
		#LeatherArmor.class,
		#MailArmor.class,
		#ScaleArmor.class,
		#PlateArmor.class };
	#Category.ARMOR.probs = new float[]{ 1, 1, 1, 1, 1 };
#
	#Category.FOOD.classes = new Class<?>[]{
		#Food.class,
		#Pasty.class,
		#MysteryMeat.class };
	#Category.FOOD.probs = new float[]{ 4, 1, 0 };
#
	#Category.RING.classes = new Class<?>[]{
		#RingOfMending.class,
		#RingOfDetection.class,
		#RingOfShadows.class,
		#RingOfPower.class,
		#RingOfHerbalism.class,
		#RingOfAccuracy.class,
		#RingOfEvasion.class,
		#RingOfSatiety.class,
		#RingOfHaste.class,
		#RingOfElements.class,
		#RingOfHaggler.class,
		#RingOfThorns.class };
	#Category.RING.probs = new float[]{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0 };
#
	#Category.SEED.classes = new Class<?>[]{
		#Firebloom.Seed.class,
		#Icecap.Seed.class,
		#Sorrowmoss.Seed.class,
		#Dreamweed.Seed.class,
		#Sungrass.Seed.class,
		#Earthroot.Seed.class,
		#Fadeleaf.Seed.class,
		#Rotberry.Seed.class };
	#Category.SEED.probs = new float[]{ 1, 1, 1, 1, 1, 1, 1, 0 };
#
	#Category.MISC.classes = new Class<?>[]{
		#Bomb.class,
		#Honeypot.class};
	#Category.MISC.probs = new float[]{ 2, 1 };
#}
