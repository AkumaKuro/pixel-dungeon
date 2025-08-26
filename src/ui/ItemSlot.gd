class_name ItemSlot
extends PButton

const DEGRADED: int	= 0xFF4444;
const UPGRADED: int	= 0x44FF44;
const WARNING: int		= 0xFF8800;

const ENABLED: float	= 1.0
const DISABLED: float	= 0.3

var icon: ItemSprite
var topLeft: BitmapText
var topRight: BitmapText
var bottomRight: BitmapText

const TXT_STRENGTH: String	= ":%d";
const TXT_TYPICAL_STR: String	= "%d?";

const TXT_LEVEL: String	= "%+d";
const TXT_CURSED: String	= "";#"-";

# Special "virtual items"
const CHEST: Item = Item.new()
#CHEST.image.bind(
	#func() -> int:
		#return ItemSpriteSheet.CHEST;
#)
const LOCKED_CHEST: Item = Item.new()
 #= new Item() {
	#public int image() { return ItemSpriteSheet.LOCKED_CHEST; };
#};
const TOMB: Item = Item.new()
 #= new Item() {
	#public int image() { return ItemSpriteSheet.TOMB; };
#};
const SKELETON: Item = Item.new()
 #= new Item() {
	#public int image() { return ItemSpriteSheet.BONES; };
#};

func _init() -> void:
	super();


func _init_i(item: Item) -> void:
	Item.new();
	item( item );


#@Override
func createChildren() -> void:

	super.createChildren();

	icon = ItemSprite.new();
	add( icon );

	topLeft = BitmapText.new( PixelScene.font1x );
	add( topLeft );

	topRight = BitmapText.new( PixelScene.font1x );
	add( topRight );

	bottomRight = BitmapText.new( PixelScene.font1x );
	add( bottomRight );


#@Override
func layout() -> void:
	super.layout();

	icon.x = x + (width - icon.width) / 2;
	icon.y = y + (height - icon.height) / 2;

	if (topLeft != null):
		topLeft.x = x;
		topLeft.y = y;


	if (topRight != null):
		topRight.x = x + (width - topRight.width());
		topRight.y = y;


	if (bottomRight != null):
		bottomRight.x = x + (width - bottomRight.width());
		bottomRight.y = y + (height - bottomRight.height());



func item(item: Item) -> void:
	if (item == null):

		active = false;
		icon.visible = false
		topLeft.visible = false
		topRight.visible = false
		bottomRight.visible = false;

	else:

		active = true;
		icon.visible = true
		topLeft.visible = true
		topRight.visible = true
		bottomRight.visible = true;

		icon.view( item.image(), item.glowing() );

		topLeft.text( item.status()  );

		var isArmor: bool = item is Armor;
		var isWeapon: bool = item is Weapon;
		if (isArmor || isWeapon):

			if (item.levelKnown || (isWeapon && !(item is MeleeWeapon))):

				var str: int = (item as Armor).STR if isArmor else (item as Weapon).STR;
				topRight.text( Utils.format( TXT_STRENGTH, str ) );
				if (str > Dungeon.hero.STR()):
					topRight.hardlight( DEGRADED );
				else:
					topRight.resetColor();


			else:

				topRight.text( Utils.format( TXT_TYPICAL_STR,
					(item as Armor).typicalSTR() if isArmor else
					(item as MeleeWeapon).typicalSTR() ) );
				topRight.hardlight( WARNING );


			topRight.measure();

		else:

			topRight.text( null );



		var level: int = item.visiblyUpgraded();
		if (level != 0 || (item.cursed && item.cursedKnown)):
			bottomRight.text( Utils.format( TXT_LEVEL, level ) if item.levelKnown else TXT_CURSED );
			bottomRight.measure();

			var hard_light: int

			if level > 0:
				if item.isBroken():
					hard_light = WARNING
				else:
					hard_light = UPGRADED
			else:
				hard_light = DEGRADED

			bottomRight.hardlight(hard_light);
		else:
			bottomRight.text( null );


		layout();



func enable(value: bool) -> void:

	active = value;

	var alpha: float = ENABLED if value else DISABLED;
	icon.alpha( alpha );
	topLeft.alpha( alpha );
	topRight.alpha( alpha );
	bottomRight.alpha( alpha );


func showParams(value: bool) -> void:
	if (value):
		add( topRight );
		add( bottomRight );
	else:
		remove( topRight );
		remove( bottomRight );
