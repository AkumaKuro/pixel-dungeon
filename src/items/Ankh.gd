class_name Ankh
extends Item

func _init() -> void:
	stackable = true;
	name = "Ankh";
	image = ItemSpriteSheet.ANKH;


#@Override
func isUpgradable() -> bool:
	return false;


#@Override
func isIdentified() -> bool:
	return true;


#@Override
func info() -> String:
	return \
		"The ancient symbol of immortality grants an ability to return to life after death. " + \
		"Upon resurrection all non-equipped items are lost.";


#@Override
func price() -> int:
	return 50 * quantity;
