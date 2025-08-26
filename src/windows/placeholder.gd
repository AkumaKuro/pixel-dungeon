class_name Placeholder
extends Item

func _init(image: int) -> void:
	name = ''
	self.image = image;


#@Override
func isIdentified() -> bool:
	return true;


#@Override
func isEquipped(hero: Hero) -> bool:
	return true;
