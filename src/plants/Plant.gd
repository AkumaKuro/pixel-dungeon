class_name Plant
extends Bundlable


var plantName: String

var image: int
var pos: int

var sprite: PlantSprite

func activate(ch: Char) -> void:

	if (ch is Hero && (ch as Hero).subClass == HeroSubClass.WARDEN):
		Buff.affect( ch, Barkskin.class ).level( ch.HT / 3 );


	wither();


func wither() -> void:
	Dungeon.level.uproot( pos );

	sprite.kill();
	if (Dungeon.visible[pos]):
		CellEmitter.get( pos ).burst( LeafParticle.GENERAL, 6 );


	if (Dungeon.hero.subClass == HeroSubClass.WARDEN):
		if (Random.Int( 5 ) == 0):
			Dungeon.level.drop( Generator.random( Generator.Category.SEED ), pos ).sprite.drop();

		if (Random.Int( 5 ) == 0):
			Dungeon.level.drop(Dewdrop.new(), pos ).sprite.drop();




const POS: String = "pos"

#@Override
func restoreFromBundle(bundle: Bundle) -> void:
	pos = bundle.getInt( POS );


#@Override
func storeInBundle(bundle: Bundle) -> void:
	bundle.put( POS, pos );


func desc() -> String:
	return null;
