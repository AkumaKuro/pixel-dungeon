class_name BagTab
extends Tab

var icon: Image

var bag: Bag

func _init(bag: Bag ) -> void:
	super();

	this.bag = bag;

	icon = icon();
	add( icon );


#@Override
func select(value: bool) -> void:
	super.select( value );
	icon.am = 1.0 if selected else 0.6


#@Override
func layout() -> void:
	super.layout();

	icon.copy( icon() );
	icon.x = x + (width - icon.width) / 2;
	icon.y = y + (height - icon.height) / 2 - 2 - (0 if selected else 1);
	if (!selected && icon.y < y + CUT):
		var frame: RectF = icon.frame();
		frame.top += (y + CUT - icon.y) / icon.texture.height;
		icon.frame( frame );
		icon.y = y + CUT;



func get_icon() -> Image:
	if (bag is SeedPouch):
		return Icons.get( Icons.SEED_POUCH );
	elif (bag is ScrollHolder):
		return Icons.get( Icons.SCROLL_HOLDER );
	elif (bag is WandHolster):
		return Icons.get( Icons.WAND_HOLSTER );
	elif (bag is Keyring):
		return Icons.get( Icons.KEYRING );
	else:
		return Icons.get( Icons.BACKPACK );
