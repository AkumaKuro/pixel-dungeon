class_name Bag
extends Item  #implements Iterable<Item> {

const AC_OPEN: String = "OPEN";

func _init() -> void:
	image = 11;

	defaultAction = AC_OPEN;


var owner: Char

var items: Array[Item] = []

var size: int = 1;

#@Override
func actions(hero: Hero) -> PackedStringArray:
	var actions: PackedStringArray = super.actions( hero );
	return actions;


#@Override
func execute_action(hero: Hero, action: String) -> void:
	if action == AC_OPEN:
		GameScene.show(WndBag.new( self, null, WndBag.Mode.ALL, null ) );

	else:
		super.execute_action( hero, action );

#@Override
func collect_bag(container: Bag) -> bool:
	if (super.collect_bag( container )):

		owner = container.owner;

		for item: Item in container.items:
			if (grab( item )):
				item.detachAll( container );
				item.collect_bag( self );



		Badges.validateAllBagsBought( self );

		return true;
	else:
		return false;



#@Override
func onDetach( ) -> void:
	this.owner = null;


#@Override
func isUpgradable() -> bool:
	return false;


#@Override
func isIdentified() -> bool:
	return true;


func clear() -> void:
	items.clear();


const ITEMS: String = "inventory";

#@Override
func storeInBundle(bundle: Bundle) -> void:
	super.storeInBundle( bundle );
	bundle.put( ITEMS, items );


#@Override
func restoreFromBundle(bundle: Bundle) -> void:
	super.restoreFromBundle( bundle );
	for item: Bundlable in bundle.getCollection( ITEMS ):
		(item as Item).collect( this );



func contains(item: Item) -> bool:
	for i: Item in items:
		if (i == item):
			return true;
		elif (i is Bag && (i as Bag).contains( item )):
			return true;

	return false;


func grab(item: Item) -> bool:
	return false;


#@Override
#public Iterator<Item> iterator() {
	#return new ItemIterator();
#}
#
#class ItemIterator:
#
	#var index: int = 0;
	#private Iterator<Item> nested = null;
#
	##@Override
	#public boolean hasNext() {
		#if (nested != null) {
			#return nested.hasNext() || index < items.size();
		#} else {
			#return index < items.size();
		#}
	#}
#
	##@Override
	#public Item next() {
		#if (nested != null && nested.hasNext()) {
#
			#return nested.next();
#
		#} else {
#
			#nested = null;
#
			#Item item = items.get( index++ );
			#if (item instanceof Bag) {
				#nested = ((Bag)item).iterator();
			#}
#
			#return item;
		#}
	#}
#
	#@Override
	#public void remove() {
		#if (nested != null) {
			#nested.remove();
		#} else {
			#items.remove( index );
		#}
	#}
#}
#}
