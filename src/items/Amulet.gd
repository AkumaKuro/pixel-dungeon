class_name Amulet
extends Item

const AC_END: String = "END THE GAME";

func _init() -> void:
	name = "Amulet of Yendor";
	image = ItemSpriteSheet.AMULET;

	unique = true;


#@Override
func actions(hero: Hero) -> PackedStringArray:
	var actions: PackedStringArray = super.actions( hero );
	actions.add( AC_END );
	return actions;


#@Override
func execute(hero: Hero, action: String) -> void:
	if (action == AC_END):

		showAmuletScene( false );

	else:

		super.execute( hero, action );




#@Override
func doPickUp(hero: Hero) -> bool:
	if (super.doPickUp( hero )):

		if (!Statistics.amuletObtained):
			Statistics.amuletObtained = true;
			Badges.validateVictory();

			showAmuletScene( true );

		return true;
	else:
		return false;



func showAmuletScene(showText: bool) -> void:
	Dungeon.saveAll();
	AmuletScene.noText = !showText;
	Game.switchScene( AmuletScene.class );

#@Override
func isIdentified() -> bool:
	return true;


#@Override
func isUpgradable() -> bool:
	return false;


#@Override
func info() -> String:
	return \
		"The Amulet of Yendor is the most powerful known artifact of unknown origin. It is said that the amulet " + \
		"is able to fulfil any wish if its owner's will-power is strong enough to \"persuade\" it to do it.";
