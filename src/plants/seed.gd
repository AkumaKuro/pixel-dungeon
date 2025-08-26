class_name Seed
extends Item

const AC_PLANT: String = "PLANT";

const TXT_INFO: String = "Throw this seed to the place where you want to grow %s.\n\n%s";

const TIME_TO_PLANT: float = 1

func _init() -> void:
	stackable = true;
	defaultAction = AC_THROW;


var plantClass: Plant
var plantName: String

var alchemyClass: Item

#@Override
func actions(hero: Hero) -> PackedStringArray:
	var actions: PackedStringArray = super.actions( hero );
	actions.add( AC_PLANT );
	return actions;


#@Override
func onThrow(cell: int) -> void:
	if (Dungeon.level.map[cell] == Terrain.ALCHEMY || Level.pit[cell]):
		super.onThrow( cell );
	else:
		Dungeon.level.plant( this, cell );



#@Override
func execute( hero: Hero, action: String) -> void:
	if (action.equals( AC_PLANT )):

		hero.spend( TIME_TO_PLANT );
		hero.busy();
		(detach( hero.belongings.backpack ) as Seed).onThrow( hero.pos );

		hero.sprite.operate( hero.pos );

	else:

		super.execute (hero, action );




func couch( pos: int) -> Plant:

	if (Dungeon.visible[pos]):
		Sample.INSTANCE.play( Assets.SND_PLANT );

	var plant: Plant = plantClass.newInstance();
	plant.pos = pos;
	return plant;

#@Override
func isUpgradable() -> bool:
	return false;


#@Override
func isIdentified() -> bool:
	return true;


#@Override
func price() -> int:
	return 10 * quantity;


#@Override
func info() -> String:
	return String.format( TXT_INFO, Utils.indefinite( plantName ), desc() );
