@abstract class_name Char
extends Actor

const TXT_HIT: String		= "%s hit %s";
const TXT_KILL: String		= "%s killed you...";
const TXT_DEFEAT: String	= "%s defeated %s";

const TXT_YOU_MISSED: String	= "%s %s your attack";
const TXT_SMB_MISSED: String	= "%s %s %s's attack";

const TXT_OUT_OF_PARALYSIS: String	= "The pain snapped %s out of paralysis";

var pos: int = 0;

var sprite: CharSprite

var name: String = "mob";

var HT: int;
var HP: int;

var baseSpeed: float	= 1;

var paralysed: bool	= false;
var rooted: bool		= false;
var flying: bool		= false;
var invisible: int		= 0;

var viewDistance: int	= 8;

var buffs: Array[Buff] = [] # TODO HashSet

#@Override
func act() -> bool:
	Dungeon.level.updateFieldOfView( self );
	return false;


const POS: String			= "pos";
const TAG_HP: String		= "HP";
const TAG_HT: String		= "HT";
const BUFFS: String		= "buffs";

#@Override
func storeInBundle(bundle: Bundle) -> void:

	super.storeInBundle( bundle );

	bundle.put( POS, pos );
	bundle.put( TAG_HP, HP );
	bundle.put( TAG_HT, HT );
	bundle.put( BUFFS, buffs );


#@Override
func restoreFromBundle(bundle: Bundle) -> void:

	super.restoreFromBundle( bundle );

	pos = bundle.getInt( POS );
	HP = bundle.getInt( TAG_HP );
	HT = bundle.getInt( TAG_HT );

	for b: Bundlable in bundle.getCollection( BUFFS ):
		if (b != null):
			(b as Buff).attachTo( self );




func attack(enemy: Char) -> bool:

	var visibleFight: bool = Dungeon.visible[pos] || Dungeon.visible[enemy.pos];

	if (hit( this, enemy, false )):

		if (visibleFight):
			GLog.i( TXT_HIT, name, enemy.name );


		# FIXME
		var dr: int
		if self is Hero && (self as Hero).rangedWeapon != null && (self as Hero).subClass == HeroSubClass.SNIPER:
			dr = 0
		else:
			dr = Random.IntRange( 0, enemy.dr() );

		var dmg: int = damageRoll();
		var effectiveDamage: int = Math.max( dmg - dr, 0 );

		effectiveDamage = attackProc( enemy, effectiveDamage );
		effectiveDamage = enemy.defenseProc( this, effectiveDamage );
		enemy.damage( effectiveDamage, this );

		if (visibleFight):
			Sample.INSTANCE.play( Assets.SND_HIT, 1, 1, Random.Float( 0.8, 1.25) );


		if (enemy == Dungeon.hero):
			Dungeon.hero.interrupt();
			if (effectiveDamage > enemy.HT / 4):
				Camera.main.shake( GameMath.gate( 1, effectiveDamage / (enemy.HT / 4), 5), 0.3);



		enemy.sprite.bloodBurstA( sprite.center(), effectiveDamage );
		enemy.sprite.flash();

		if (!enemy.isAlive() && visibleFight):
			if (enemy == Dungeon.hero):

				if (Dungeon.hero.killerGlyph != null):
					pass
				# FIXME
				#	Dungeon.fail( Utils.format( ResultDescriptions.GLYPH, Dungeon.hero.killerGlyph.name(), Dungeon.depth ) );
				#	GLog.n( TXT_KILL, Dungeon.hero.killerGlyph.name() );

				else:
					if (Bestiary.isBoss( this )):
						Dungeon.fail( Utils.format( ResultDescriptions.BOSS, name, Dungeon.depth ) );
					else:
						Dungeon.fail( Utils.format( ResultDescriptions.MOB,
							Utils.indefinite( name ), Dungeon.depth ) );


					GLog.n( TXT_KILL, name );


			else:
				GLog.i( TXT_DEFEAT, name, enemy.name );



		return true;

	else:

		if (visibleFight):
			var defense: String = enemy.defenseVerb();
			enemy.sprite.showStatus( CharSprite.NEUTRAL, defense );
			if (this == Dungeon.hero):
				GLog.i( TXT_YOU_MISSED, enemy.name, defense );
			else:
				GLog.i( TXT_SMB_MISSED, enemy.name, defense, name );


			Sample.INSTANCE.play( Assets.SND_MISS );


		return false;




static func hit( attacker: Char, defender: Char, magic: bool ) -> bool:
	var acuRoll: float = Random.Float( attacker.attackSkill( defender ) );
	var defRoll: float = Random.Float( defender.defenseSkill( attacker ) );
	return (acuRoll * 2 if magic else acuRoll) >= defRoll;


func attackSkill(target: Char ) -> int:
	return 0;

func defenseSkill(enemy: Char) -> int:
	return 0;


func defenseVerb() -> String:
	return "dodged";


func dr() -> int:
	return 0;


func damageRoll() -> int:
	return 1;


func attackProc(enemy: Char, damage: int) -> int:
	return damage;


func defenseProc(enemy: Char, damage: int) -> int:
	return damage;


func speed() -> float:
	return baseSpeed if buff( Cripple.class ) == null else baseSpeed * 0.5


func damage(dmg: int, src: Object) -> void:

	if (HP <= 0):
		return;


	Buff.detach( this, Frost.class );

	var srcClass = src.getClass();
	if (immunities().contains( srcClass )):
		dmg = 0;
	elif (resistances().contains( srcClass )):
		dmg = Random.IntRange( 0, dmg );


	if (buff( Paralysis.class ) != null):
		if (Random.Int( dmg ) >= Random.Int( HP )):
			Buff.detach( this, Paralysis.class );
			if (Dungeon.visible[pos]):
				GLog.i( TXT_OUT_OF_PARALYSIS, name );




	HP -= dmg;
	if (dmg > 0 || src is Char):
		sprite.showStatus(CharSprite.WARNING if HP > HT / 2 else CharSprite.NEGATIVE,
			Integer.toString( dmg ) );

	if (HP <= 0):
		die( src );



func destroy() -> void:
	HP = 0;
	Actor.remove( this );
	Actor.freeCell( pos );


func die(src: Object) -> void:
	destroy();
	sprite.die();


func isAlive() -> bool:
	return HP > 0;


#@Override
func spend(time: float) -> void:

	var timeScale: float = 1
	if (buff( Slow.class ) != null):
		timeScale *= 0.5

	if (buff( Speed.class ) != null):
		timeScale *= 2.0


	super.spend( time / timeScale );


func get_buffs() -> Array[Buff]:
	return buffs;


#@SuppressWarnings("unchecked")
func get_buffs_c(c) -> Array:
	var filtered: Array = []
	for b: Buff in buffs:
		if (c.isInstance( b )):
			filtered.add(b);
	return filtered;


#@SuppressWarnings("unchecked")
func buff(c) -> Buff:
	for b: Buff in buffs:
		if (c.isInstance( b )):
			return b;


	return null;


func isCharmedBy(ch: Char) -> bool:
	var chID: int = ch.id();
	for b: Buff in buffs:
		if (b is Charm && (b as Charm).object == chID):
			return true;


	return false;


func add( buff: Buff) -> void:

	buffs.add( buff );
	Actor.add( buff );

	if (sprite != null):
		if (buff is Poison):

			CellEmitter.center( pos ).burst( PoisonParticle.SPLASH, 5 );
			sprite.showStatus( CharSprite.NEGATIVE, "poisoned" );

		elif (buff is Amok):

			sprite.showStatus( CharSprite.NEGATIVE, "amok" );

		elif (buff is Slow):

			sprite.showStatus( CharSprite.NEGATIVE, "slowed" );

		elif (buff is MindVision):

			sprite.showStatus( CharSprite.POSITIVE, "mind" );
			sprite.showStatus( CharSprite.POSITIVE, "vision" );

		elif (buff is Paralysis):

			sprite.add( CharSprite.State.PARALYSED );
			sprite.showStatus( CharSprite.NEGATIVE, "paralysed" );

		elif (buff is Terror):

			sprite.showStatus( CharSprite.NEGATIVE, "frightened" );

		elif (buff is Roots):

			sprite.showStatus( CharSprite.NEGATIVE, "rooted" );

		elif (buff is Cripple):

			sprite.showStatus( CharSprite.NEGATIVE, "crippled" );

		elif (buff is Bleeding):

			sprite.showStatus( CharSprite.NEGATIVE, "bleeding" );

		elif (buff is Vertigo):

			sprite.showStatus( CharSprite.NEGATIVE, "dizzy" );

		elif (buff is Sleep):
			sprite.idle();


		elif (buff is Burning):
			sprite.add( CharSprite.State.BURNING );
		elif (buff is Levitation):
			sprite.add( CharSprite.State.LEVITATING );
		elif (buff is Frost):
			sprite.add( CharSprite.State.FROZEN );
		elif (buff is Invisibility):
			if (!(buff is Shadows)):
				sprite.showStatus( CharSprite.POSITIVE, "invisible" );

			sprite.add( CharSprite.State.INVISIBLE );




func remove(buff: Buff) -> void:

	buffs.remove( buff );
	Actor.remove( buff );

	if (buff is Burning):
		sprite.remove( CharSprite.State.BURNING );
	elif (buff is Levitation):
		sprite.remove( CharSprite.State.LEVITATING );
	elif (buff is Invisibility && invisible <= 0):
		sprite.remove( CharSprite.State.INVISIBLE );
	elif (buff is Paralysis):
		sprite.remove( CharSprite.State.PARALYSED );
	elif (buff is Frost):
		sprite.remove( CharSprite.State.FROZEN );



func remove_buff(buffClass: Buff) -> void:
	for buff: Buff in buffs( buffClass ):
		remove( buff );





#@Override
func onRemove() -> void:
	for buff: Buff in buffs.toArray( Buff.new[0] ):
		buff.detach();



func updateSpriteState() -> void:
	for buff: Buff in buffs:
		if (buff is Burning):
			sprite.add( CharSprite.State.BURNING );
		elif (buff is Levitation):
			sprite.add( CharSprite.State.LEVITATING );
		elif (buff is Invisibility):
			sprite.add( CharSprite.State.INVISIBLE );
		elif (buff is Paralysis):
			sprite.add( CharSprite.State.PARALYSED );
		elif (buff is Frost):
			sprite.add( CharSprite.State.FROZEN );
		elif (buff is Light):
			sprite.add( CharSprite.State.ILLUMINATED );




func stealth() -> int:
	return 0;


func move(step: int) -> void:

	if (Level.adjacent( step, pos ) && buff( Vertigo.class ) != null):
		step = pos + Level.NEIGHBOURS8[Random.Int( 8 )];
		if (!(Level.passable[step] || Level.avoid[step]) || Actor.findChar( step ) != null):
			return;



	if (Dungeon.level.map[pos] == Terrain.OPEN_DOOR):
		Door.leave( pos );


	pos = step;

	if (flying && Dungeon.level.map[pos] == Terrain.DOOR):
		Door.enter( pos );


	if (this != Dungeon.hero):
		sprite.visible = Dungeon.visible[pos];



func distance(other: Char) -> int:
	return Level.distance( pos, other.pos );


func onMotionComplete() -> void:
	next();


func onAttackComplete() -> void:
	next();


func onOperateComplete() -> void:
	next();


const EMPTY = []

func resistances() -> Array:
	return EMPTY;


func immunities() -> Array:
	return EMPTY;
