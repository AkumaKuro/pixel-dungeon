class_name WndBag
extends WndTabbed


enum Mode {
	ALL,
	UNIDENTIFED,
	UPGRADEABLE,
	QUICKSLOT,
	FOR_SALE,
	WEAPON,
	ARMOR,
	ENCHANTABLE,
	WAND,
	SEED
}

const COLS_P: int	= 4;
const COLS_L: int	= 6;

const SLOT_SIZE: int	= 28;
const SLOT_MARGIN: int	= 1;

const TAB_WIDTH: int	= 25;

const TITLE_HEIGHT: int	= 12;

var listener: WndBag.Listener
var mode: WndBag.Mode
var title: String

var nCols: int
var nRows: int

var count: int
var col: int
var row: int

static var lastMode: Mode
static var lastBag: Bag

func _init(bag: Bag, listener: WndBag.Listener, mode: Mode, title: String) -> void:

	super();

	this.listener = listener;
	this.mode = mode;
	this.title = title;

	lastMode = mode;
	lastBag = bag;

	nCols = COLS_L if PixelDungeon.landscape() else COLS_P;
	nRows = (Belongings.BACKPACK_SIZE + 4 + 1) / nCols + (1 if (Belongings.BACKPACK_SIZE + 4 + 1) % nCols > 0 else 0);

	var slotsWidth: int = SLOT_SIZE * nCols + SLOT_MARGIN * (nCols - 1);
	var slotsHeight: int = SLOT_SIZE * nRows + SLOT_MARGIN * (nRows - 1);

	var txtTitle: BitmapText = PixelScene.createText(title if title != null else Utils.capitalize( bag.name() ), 9 );
	txtTitle.hardlight( TITLE_COLOR );
	txtTitle.measure();
	txtTitle.x = (int)(slotsWidth - txtTitle.width()) / 2;
	txtTitle.y = (int)(TITLE_HEIGHT - txtTitle.height()) / 2;
	add( txtTitle );

	placeItems( bag );

	resize( slotsWidth, slotsHeight + TITLE_HEIGHT );

	var stuff: Belongings = Dungeon.hero.belongings;
	var bags: Array[Bag] = [
		stuff.backpack,
		stuff.getItem( SeedPouch.class ),
		stuff.getItem( ScrollHolder.class ),
		stuff.getItem( WandHolster.class ),
		stuff.getItem( Keyring.class )
	]

	for b: Bag in bags:
		if (b != null):
			var tab: BagTab = BagTab.new( b );
			tab.setSize( TAB_WIDTH, tabHeight() );
			add( tab );

			tab.select( b == bag );




static func get_lastBag(listener: Listener, mode: Mode, title: String) -> WndBag:

	if (mode == lastMode && lastBag != null &&
		Dungeon.hero.belongings.backpack.contains( lastBag )):

		return WndBag.new( lastBag, listener, mode, title );

	else:

		return WndBag.new( Dungeon.hero.belongings.backpack, listener, mode, title );




static func seedPouch(listener: Listener, mode: Mode, title: String) -> WndBag:
	var pouch: SeedPouch = Dungeon.hero.belongings.getItem( SeedPouch.class );
	return \
		WndBag.new( pouch, listener, mode, title ) if pouch != null else \
		WndBag.new( Dungeon.hero.belongings.backpack, listener, mode, title );


func placeItems(container: Bag) -> void:

	# Equipped items
	var stuff: Belongings = Dungeon.hero.belongings;
	placeItem( stuff.weapon if stuff.weapon != null else Placeholder.new( ItemSpriteSheet.WEAPON ) );
	placeItem( stuff.armor if stuff.armor != null else Placeholder.new( ItemSpriteSheet.ARMOR ) );
	placeItem( stuff.ring1 if stuff.ring1 != null else Placeholder.new( ItemSpriteSheet.RING ) );
	placeItem( stuff.ring2 if stuff.ring2 != null else Placeholder.new( ItemSpriteSheet.RING ) );

	var backpack: bool = (container == Dungeon.hero.belongings.backpack);
	if (!backpack):
		count = nCols;
		col = 0;
		row = 1;


	# Items in the bag
	for item: Item in container.items:
		placeItem( item );


	# Free space
	while count-(4 if backpack else nCols) < container.size:
		placeItem( null );


	# Gold in the backpack
	if (container == Dungeon.hero.belongings.backpack):
		row = nRows - 1;
		col = nCols - 1;
		placeItem( Gold.new( Dungeon.gold ) );



func placeItem(item: Item) -> void:

	var x: int = col * (SLOT_SIZE + SLOT_MARGIN);
	var y: int = TITLE_HEIGHT + row * (SLOT_SIZE + SLOT_MARGIN);

	add(ItemButton.new( item ).setPos( x, y ) );

	col += 1
	if (col >= nCols):
		col = 0;
		row += 1


	count += 1


#@Override
func onMenuPressed() -> void:
	if (listener == null):
		hide();



#@Override
func onBackPressed() -> void:
	if (listener != null):
		listener.onSelect( null );

	super.onBackPressed();


#@Override
func onClick(tab: Tab) -> void:
	hide();
	GameScene.show(WndBag.new( (tab as BagTab).bag, listener, mode, title ) );


#@Override
func tabHeight() -> int:
	return 20;









public interface Listener {
	void onSelect( Item item );
}
}
