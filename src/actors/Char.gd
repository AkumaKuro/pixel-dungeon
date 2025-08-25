#/*
 #* Pixel Dungeon
 #* Copyright (C) 2012-2015 Oleg Dolya
 #*
 #* This program is free software: you can redistribute it and/or modify
 #* it under the terms of the GNU General Public License as published by
 #* the Free Software Foundation, either version 3 of the License, or
 #* (at your option) any later version.
 #*
 #* This program is distributed in the hope that it will be useful,
 #* but WITHOUT ANY WARRANTY; without even the implied warranty of
 #* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 #* GNU General Public License for more details.
 #*
 #* You should have received a copy of the GNU General Public License
 #* along with this program.  If not, see <http://www.gnu.org/licenses/>
 #*/

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
	Dungeon.level.updateFieldOfView( this );
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
}

func defenseVerb() -> String:
	return "dodged";
}

func dr() -> int:
	return 0;
}

func damageRoll() -> int:
	return 1;
}

func attackProc( Char enemy, int damage ) -> int:
	return damage;
}

public int defenseProc( Char enemy, int damage ) {
	return damage;
}

public float speed() {
	return buff( Cripple.class ) == null ? baseSpeed : baseSpeed * 0.5f;
}

public void damage( int dmg, Object src ) {

	if (HP <= 0) {
		return;
	}

	Buff.detach( this, Frost.class );

	Class<?> srcClass = src.getClass();
	if (immunities().contains( srcClass )) {
		dmg = 0;
	} else if (resistances().contains( srcClass )) {
		dmg = Random.IntRange( 0, dmg );
	}

	if (buff( Paralysis.class ) != null) {
		if (Random.Int( dmg ) >= Random.Int( HP )) {
			Buff.detach( this, Paralysis.class );
			if (Dungeon.visible[pos]) {
				GLog.i( TXT_OUT_OF_PARALYSIS, name );
			}
		}
	}

	HP -= dmg;
	if (dmg > 0 || src instanceof Char) {
		sprite.showStatus( HP > HT / 2 ?
			CharSprite.WARNING :
			CharSprite.NEGATIVE,
			Integer.toString( dmg ) );
	}
	if (HP <= 0) {
		die( src );
	}
}

public void destroy() {
	HP = 0;
	Actor.remove( this );
	Actor.freeCell( pos );
}

public void die( Object src ) {
	destroy();
	sprite.die();
}

public boolean isAlive() {
	return HP > 0;
}

@Override
protected void spend( float time ) {

	float timeScale = 1f;
	if (buff( Slow.class ) != null) {
		timeScale *= 0.5f;
	}
	if (buff( Speed.class ) != null) {
		timeScale *= 2.0f;
	}

	super.spend( time / timeScale );
}

public HashSet<Buff> buffs() {
	return buffs;
}

@SuppressWarnings("unchecked")
public <T extends Buff> HashSet<T> buffs( Class<T> c ) {
	HashSet<T> filtered = new HashSet<T>();
	for (Buff b : buffs) {
		if (c.isInstance( b )) {
			filtered.add( (T)b );
		}
	}
	return filtered;
}

@SuppressWarnings("unchecked")
public <T extends Buff> T buff( Class<T> c ) {
	for (Buff b : buffs) {
		if (c.isInstance( b )) {
			return (T)b;
		}
	}
	return null;
}

public boolean isCharmedBy( Char ch ) {
	int chID = ch.id();
	for (Buff b : buffs) {
		if (b instanceof Charm && ((Charm)b).object == chID) {
			return true;
		}
	}
	return false;
}

public void add( Buff buff ) {

	buffs.add( buff );
	Actor.add( buff );

	if (sprite != null) {
		if (buff instanceof Poison) {

			CellEmitter.center( pos ).burst( PoisonParticle.SPLASH, 5 );
			sprite.showStatus( CharSprite.NEGATIVE, "poisoned" );

		} else if (buff instanceof Amok) {

			sprite.showStatus( CharSprite.NEGATIVE, "amok" );

		} else if (buff instanceof Slow) {

			sprite.showStatus( CharSprite.NEGATIVE, "slowed" );

		} else if (buff instanceof MindVision) {

			sprite.showStatus( CharSprite.POSITIVE, "mind" );
			sprite.showStatus( CharSprite.POSITIVE, "vision" );

		} else if (buff instanceof Paralysis) {

			sprite.add( CharSprite.State.PARALYSED );
			sprite.showStatus( CharSprite.NEGATIVE, "paralysed" );

		} else if (buff instanceof Terror) {

			sprite.showStatus( CharSprite.NEGATIVE, "frightened" );

		} else if (buff instanceof Roots) {

			sprite.showStatus( CharSprite.NEGATIVE, "rooted" );

		} else if (buff instanceof Cripple) {

			sprite.showStatus( CharSprite.NEGATIVE, "crippled" );

		} else if (buff instanceof Bleeding) {

			sprite.showStatus( CharSprite.NEGATIVE, "bleeding" );

		} else if (buff instanceof Vertigo) {

			sprite.showStatus( CharSprite.NEGATIVE, "dizzy" );

		} else if (buff instanceof Sleep) {
			sprite.idle();
		}

		  else if (buff instanceof Burning) {
			sprite.add( CharSprite.State.BURNING );
		} else if (buff instanceof Levitation) {
			sprite.add( CharSprite.State.LEVITATING );
		} else if (buff instanceof Frost) {
			sprite.add( CharSprite.State.FROZEN );
		} else if (buff instanceof Invisibility) {
			if (!(buff instanceof Shadows)) {
				sprite.showStatus( CharSprite.POSITIVE, "invisible" );
			}
			sprite.add( CharSprite.State.INVISIBLE );
		}
	}
}

public void remove( Buff buff ) {

	buffs.remove( buff );
	Actor.remove( buff );

	if (buff instanceof Burning) {
		sprite.remove( CharSprite.State.BURNING );
	} else if (buff instanceof Levitation) {
		sprite.remove( CharSprite.State.LEVITATING );
	} else if (buff instanceof Invisibility && invisible <= 0) {
		sprite.remove( CharSprite.State.INVISIBLE );
	} else if (buff instanceof Paralysis) {
		sprite.remove( CharSprite.State.PARALYSED );
	} else if (buff instanceof Frost) {
		sprite.remove( CharSprite.State.FROZEN );
	}
}

public void remove( Class<? extends Buff> buffClass ) {
	for (Buff buff : buffs( buffClass )) {
		remove( buff );
	}
}



@Override
protected void onRemove() {
	for (Buff buff : buffs.toArray( new Buff[0] )) {
		buff.detach();
	}
}

public void updateSpriteState() {
	for (Buff buff:buffs) {
		if (buff instanceof Burning) {
			sprite.add( CharSprite.State.BURNING );
		} else if (buff instanceof Levitation) {
			sprite.add( CharSprite.State.LEVITATING );
		} else if (buff instanceof Invisibility) {
			sprite.add( CharSprite.State.INVISIBLE );
		} else if (buff instanceof Paralysis) {
			sprite.add( CharSprite.State.PARALYSED );
		} else if (buff instanceof Frost) {
			sprite.add( CharSprite.State.FROZEN );
		} else if (buff instanceof Light) {
			sprite.add( CharSprite.State.ILLUMINATED );
		}
	}
}

public int stealth() {
	return 0;
}

public void move( int step ) {

	if (Level.adjacent( step, pos ) && buff( Vertigo.class ) != null) {
		step = pos + Level.NEIGHBOURS8[Random.Int( 8 )];
		if (!(Level.passable[step] || Level.avoid[step]) || Actor.findChar( step ) != null) {
			return;
		}
	}

	if (Dungeon.level.map[pos] == Terrain.OPEN_DOOR) {
		Door.leave( pos );
	}

	pos = step;

	if (flying && Dungeon.level.map[pos] == Terrain.DOOR) {
		Door.enter( pos );
	}

	if (this != Dungeon.hero) {
		sprite.visible = Dungeon.visible[pos];
	}
}

public int distance( Char other ) {
	return Level.distance( pos, other.pos );
}

public void onMotionComplete() {
	next();
}

public void onAttackComplete() {
	next();
}

public void onOperateComplete() {
	next();
}

private static final HashSet<Class<?>> EMPTY = new HashSet<Class<?>>();

public HashSet<Class<?>> resistances() {
	return EMPTY;
}

public HashSet<Class<?>> immunities() {
	return EMPTY;
}
}
