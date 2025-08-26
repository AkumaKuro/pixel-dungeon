class_name Item
extends Bundlable

const TXT_PACK_FULL: String = "Your pack is too full for the %s";

const TXT_BROKEN: String		= "Because of frequent use, your %s has broken.";
const TXT_GONNA_BREAK: String	= "Because of frequent use, your %s is going to break soon.";

const TXT_TO_STRING: String		= "%s";
const TXT_TO_STRING_X: String		= "%s x%d";
const TXT_TO_STRING_LVL: String	= "%s%+d";
const TXT_TO_STRING_LVL_X: String	= "%s%+d x%d";

const DURABILITY_WARNING_LEVEL: float	= 1/6.0

const TIME_TO_THROW: float		= 1.0
const TIME_TO_PICK_UP: float	= 1.0
const TIME_TO_DROP: float		= 0.5

const AC_DROP: String = "DROP";
const AC_THROW: String = "THROW";

var defaultAction: String

var name: String = "smth";
var image: int = 0;


var stackable: bool = false;
var quantity: int = 1;

var level: int = 0;
var durability: int = maxDurability();
var levelKnown: bool = false;

var cursed: bool;
var cursedKnown: bool;

var unique: bool = false;

static var itemComparator: Comparator = Comparator.new()

func _init() -> void:
	itemComparator.compare.bind(
		func(lhs: Item, rhs: Item):
			return Generator.Category.order( lhs ) - Generator.Category.order( rhs );
	)

	thrower.onSelect.bind(
		func(target: int):
			if (target != null):
				curItem.cast( curUser, target );
	)
	thrower.prompt.bind(
		func() -> String:
			return "Choose direction of throw";
	)

func actions(hero: Hero) -> PackedStringArray:
	var actions: PackedStringArray = []
	actions.add( AC_DROP );
	actions.add( AC_THROW );
	return actions;


func doPickUp(hero: Hero) -> bool:
	if (collect( hero.belongings.backpack )):

		GameScene.pickUp( self );
		Sample.INSTANCE.play( Assets.SND_ITEM );
		hero.spendAndNext( TIME_TO_PICK_UP );
		return true;

	else:
		return false;



func doDrop(hero: Hero ) -> void:
	hero.spendAndNext( TIME_TO_DROP );
	Dungeon.level.drop( detachAll( hero.belongings.backpack ), hero.pos ).sprite.drop( hero.pos );


func doThrow(hero: Hero ) -> void:
	GameScene.selectCell( thrower );


func execute_action(hero: Hero, action: String ) -> void:

	curUser = hero;
	curItem = self;

	if (action.equals( AC_DROP )):

		doDrop( hero );

	elif (action.equals( AC_THROW )):

		doThrow( hero );




func execute(hero: Hero) -> void:
	execute( hero, defaultAction );


func onThrow(cell: int) -> void:
	var heap: Heap = Dungeon.level.drop( self, cell );
	if (!heap.isEmpty()):
		heap.sprite.drop( cell );



func collect_bag(container: Bag) -> bool:

	var items: Array[Item] = container.items;

	if (self in items):
		return true;


	for item: Item in items:
		if (item is Bag && (item as Bag).grab( self )):
			return collect(item as Bag);



	if (stackable):

		var c = getClass();
		for item: Item in items:
			if (item.getClass() == c):
				item.quantity += quantity;
				item.updateQuickslot();
				return true;




	if (items.size() < container.size):

		if (Dungeon.hero != null && Dungeon.hero.isAlive()):
			Badges.validateItemLevelAquired( this );


		items.add( this );
		QuickSlot.refresh();
		Collections.sort( items, itemComparator );
		return true;

	else:

		GLog.n( TXT_PACK_FULL, name() );
		return false;




func collect() -> bool:
	return collect( Dungeon.hero.belongings.backpack );


func detach(container: Bag) -> Item:

	if (quantity <= 0):

		return null;

	elif (quantity == 1):

		return detachAll( container );

	else:

		quantity -= 1
		updateQuickslot();


		var detached: Item = getClass().newInstance();
		detached.onDetach( );
		return detached;


func detachAll(container: Bag) -> Item:

	for item: Item in container.items:
		if (item == this):
			container.items.remove( this );
			item.onDetach( );
			QuickSlot.refresh();
			return this;
		elif (item is Bag):
			var bag: Bag = item as Bag
			if (bag.contains( this )):
				return detachAll( bag );




	return this;

func onDetach( ) -> void:
	pass


func get_level() -> int:
	return level;


func set_level(value: int) -> void:
	level = value;


func effectiveLevel() -> int:
	return  0 if isBroken() else level;


func upgrade() -> Item:

	cursed = false;
	cursedKnown = true;

	level += 1
	fix();

	return this;


func upgrade_i(n: int) -> Item:
	for i: int in range(n):
		upgrade();


	return this;


func degrade() -> Item:

	this.level -= 1
	fix();

	return this;


func degrade_i(n: int) -> Item:
	for i: int in range(n):
		degrade();


	return this;


func use() -> void:
	if (level > 0 && !isBroken()):
		var threshold: int = (maxDurability() * DURABILITY_WARNING_LEVEL);
		if (durability >= threshold && threshold > durability && levelKnown):
			GLog.w( TXT_GONNA_BREAK, name() );

		durability -= 1
		if (isBroken()):
			getBroken();
			if (levelKnown):
				GLog.n( TXT_BROKEN, name() );
				Dungeon.hero.interrupt();

				var sprite: CharSprite = Dungeon.hero.sprite;
				var point: PointF = sprite.center().offset( 0, -16 );
				if (this is Weapon):
					sprite.parent.add( Degradation.weapon( point ) );
				elif (this is Armor):
					sprite.parent.add( Degradation.armor( point ) );
				elif (this is Ring):
					sprite.parent.add( Degradation.ring( point ) );
				elif (this is Wand):
					sprite.parent.add( Degradation.wand( point ) );

				Sample.INSTANCE.play( Assets.SND_DEGRADE );





func isBroken() -> bool:
	return durability <= 0;


func getBroken() -> void:
	pass

func fix() -> void:
	durability = maxDurability();


func polish() -> void:
	if (durability < maxDurability()):
		durability += 1



func get_durability() -> int:
	return durability;


func maxDurability_l(lvl: int) -> int:
	return 1;


func maxDurability() -> int:
	return maxDurability( level );


func visiblyUpgraded() -> int:
	return level if levelKnown else 0;


func visiblyCursed() -> bool:
	return cursed && cursedKnown;


func visiblyBroken() -> bool:
	return levelKnown && isBroken();


func isUpgradable() -> bool:
	return true;


func isIdentified() -> bool:
	return levelKnown && cursedKnown;


func isEquipped(hero: Hero) -> bool:
	return false;


func identify() -> Item:

	levelKnown = true;
	cursedKnown = true;

	return this;


static func evoke(hero: Hero) -> void:
	hero.sprite.emitter().burst( Speck.factory( Speck.EVOKE ), 5 );

#@Override
func toString() -> String:

	if (levelKnown && level != 0):
		if (quantity > 1):
			return Utils.format( TXT_TO_STRING_LVL_X, name(), level, quantity );
		else:
			return Utils.format( TXT_TO_STRING_LVL, name(), level );

	else:
		if (quantity > 1):
			return Utils.format( TXT_TO_STRING_X, name(), quantity );
		else:
			return Utils.format( TXT_TO_STRING, name() );




func get_name() -> String:
	return name;


func trueName() -> String:
	return name;


func get_image() -> int:
	return image;


func glowing() -> ItemSprite.Glowing:
	return null;


func info() -> String:
	return desc();


func desc() -> String:
	return "";


func get_quantity() -> int:
	return quantity;


func set_quantity(value: int) -> void:
	quantity = value;


func price() -> int:
	return 0;


func considerState(price: int) -> int:
	if (cursed && cursedKnown):
		price /= 2;

	if (levelKnown):
		if (level > 0):
			price *= (level + 1);
			if (isBroken()):
				price /= 2;

		elif (level < 0):
			price /= (1 - level);


	if (price < 1):
		price = 1;


	return price;


static func virtual(cl: Item) -> Item:
	var item: Item = cl.newInstance() as Item
	item.quantity = 0;
	return item;

func random() -> Item:
	return this;


func status() -> String:
	return str( quantity ) if quantity != 1 else null;


func updateQuickslot() -> void:

	if (stackable):
		var cl: Item = getClass();
		if (QuickSlot.primaryValue == cl || QuickSlot.secondaryValue == cl):
			QuickSlot.refresh();

	elif (QuickSlot.primaryValue == this || QuickSlot.secondaryValue == this):
		QuickSlot.refresh();



const QUANTITY: String		= "quantity";
const LEVEL: String			= "level";
const LEVEL_KNOWN: String		= "levelKnown";
const CURSED: String			= "cursed";
const CURSED_KNOWN: String	= "cursedKnown";
const DURABILITY: String		= "durability";

#@Override
func storeInBundle(bundle: Bundle) -> void:
	bundle.put( QUANTITY, quantity );
	bundle.put( LEVEL, level );
	bundle.put( LEVEL_KNOWN, levelKnown );
	bundle.put( CURSED, cursed );
	bundle.put( CURSED_KNOWN, cursedKnown );
	if (isUpgradable()):
		bundle.put( DURABILITY, durability );

	QuickSlot.save( bundle, this );


#@Override
func restoreFromBundle(bundle: Bundle) -> void:
	quantity	= bundle.getInt( QUANTITY );
	levelKnown	= bundle.getBoolean( LEVEL_KNOWN );
	cursedKnown	= bundle.getBoolean( CURSED_KNOWN );

	var level: int = bundle.getInt( LEVEL );
	if (level > 0):
		upgrade( level );
	elif (level < 0):
		degrade( -level );


	cursed	= bundle.getBoolean( CURSED );

	if (isUpgradable()):
		durability = bundle.getInt( DURABILITY );


	QuickSlot.restore( bundle, this );


func cast(user: Hero, dst: int) -> void:

	var cell: int = Ballistica.cast( user.pos, dst, false, true );
	user.sprite.zap( cell );
	user.busy();

	Sample.INSTANCE.play( Assets.SND_MISS, 0.6, 0.6, 1.5 );

	var enemy: Char = Actor.findChar( cell );
	QuickSlot.target( this, enemy );

	# FIXME!!!
	var delay: float = TIME_TO_THROW;
	if (this is MissileWeapon):
		delay *= (this as MissileWeapon).speedFactor( user );
		if (enemy != null):
			var mark: SnipersMark = user.buff( SnipersMark.class );
			if (mark != null):
				if (mark.object == enemy.id()):
					delay *= 0.5

				user.remove( mark );



	var finalDelay: float = delay;

	var sprite: MissileSprite = user.sprite.parent.recycle( MissileSprite.class )

	sprite.reset( user.pos, cell, this,
		func():
			Item.this.detach( user.belongings.backpack ).onThrow( cell );
			user.spendAndNext( finalDelay );
	)


static var curUser: Hero = null;
static var curItem: Item = null;
static var thrower: CellSelector.Listener = CellSelector.Listener.new()
