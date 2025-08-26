class_name ItemButton
extends ItemSlot

const NORMAL: int		= 0xFF4A4D44;
const EQUIPPED: int	= 0xFF63665B;

const NBARS: int	= 3;

var item: Item
var bg: ColorBlock

var durability: Array[ColorBlock];

func _init(item: Item) -> void:

	super( item );

	this.item = item;
	if (item is Gold):
		bg.visible = false;


	width = SLOT_SIZE
	height = SLOT_SIZE;


#@Override
func createChildren() -> void:
	bg = ColorBlock.new( SLOT_SIZE, SLOT_SIZE, NORMAL );
	add( bg );

	super.createChildren();


#@Override
func layout() -> void:
	bg.x = x;
	bg.y = y;

	if (durability != null):
		for i: int in range(NBARS):
			durability[i].x = x + 1 + i * 3;
			durability[i].y = y + height - 3;



	super.layout();


#@Override
func get_item(item: Item) -> void:

	super.item( item );
	if (item != null):

		bg.texture( TextureCache.createSolid(EQUIPPED if item.isEquipped( Dungeon.hero ) else NORMAL ) );
		if (item.cursed && item.cursedKnown):
			bg.ra = +0.2
			bg.ga = -0.1
		elif (!item.isIdentified()):
			bg.ra = 0.1
			bg.ba = 0.1


		if (lastBag.owner.isAlive() && item.isUpgradable() && item.levelKnown):
			durability = []
			durability.resize(NBARS)
			var nBars: int = GameMath.gate( 0, Math.round(ZNBARS * item.durability() / item.maxDurability() ), NBARS );
			for i: int in range(nBars):
				durability[i] = ColorBlock.new( 2, 2, 0xFF00EE00 );
				add( durability[i] );

			for i: int in range(nBars, NBARS):
				durability[i] = ColorBlock.new( 2, 2, 0xFFCC0000 );
				add( durability[i] );



		if (item.name() == null):
			enable( false );
		else:
			enable(
				mode == Mode.QUICKSLOT && (item.defaultAction != null) ||
				mode == Mode.FOR_SALE && (item.price() > 0) && (!item.isEquipped( Dungeon.hero ) || !item.cursed) ||
				mode == Mode.UPGRADEABLE && item.isUpgradable() ||
				mode == Mode.UNIDENTIFED && !item.isIdentified() ||
				mode == Mode.WEAPON && (item is MeleeWeapon || item is Boomerang) ||
				mode == Mode.ARMOR && (item is Armor) ||
				mode == Mode.ENCHANTABLE && (item is MeleeWeapon || item is Boomerang || item is Armor) ||
				mode == Mode.WAND && (item is Wand) ||
				mode == Mode.SEED && (item is Seed) ||
				mode == Mode.ALL
			);

	else:
		bg.color( NORMAL );



#@Override
func onTouchDown() -> void:
	bg.brightness( 1.5 );
	Sample.INSTANCE.play( Assets.SND_CLICK, 0.7, 0.7, 1.2 );


func onTouchUp() -> void:
	bg.brightness( 1.0 );


#@Override
func onClick() -> void:
	if (listener != null):

		hide();
		listener.onSelect( item );

	else:

		WndBag.this.add(WndItem.new( WndBag.this, item ) );

#@Override
func onLongClick() -> bool:
	if (listener == null && item.defaultAction != null):
		hide();
		QuickSlot.primaryValue = item.getClass() if item.stackable else item;
		QuickSlot.refresh();
		return true;
	else:
		return false;
