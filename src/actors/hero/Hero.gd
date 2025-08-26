class_name Hero
extends Char


const TXT_LEAVE: String = "One does not simply leave Pixel Dungeon.";

const TXT_LEVEL_UP: String = "level up!";
const TXT_NEW_LEVEL: String = \
	"Welcome to level %d! Now you are healthier and more focused. " + \
	"It's easier for you to hit enemies and dodge their attacks.";

const TXT_YOU_NOW_HAVE: String = "You now have %s";

const TXT_SOMETHING_ELSE: String	= "There is something else here";
const TXT_LOCKED_CHEST: String	= "This chest is locked and you don't have matching key";
const TXT_LOCKED_DOOR: String		= "You don't have a matching key";
const TXT_NOTICED_SMTH: String	= "You noticed something";

const TXT_WAIT: String	= "...";
const TXT_SEARCH: String	= "search";

const STARTING_STR: int = 10;

const TIME_TO_REST: float		= 1
const TIME_TO_SEARCH: float	= 2

var heroClass: HeroClass = HeroClass.ROGUE;
var subClass: HeroSubClass = HeroSubClass.NONE;

var attackSkill: int = 10;
var defenseSkill: int = 5;


var ready: bool = false;

var curAction: HeroAction = null;
var lastAction: HeroAction = null;

var enemy: Char

var killerGlyph: Armor.Glyph = null;

var theKey: Item

var restoreHealth: bool = false;

var rangedWeapon: MissileWeapon = null;
var belongings: Belongings

var STR: int
var weakened: bool = false;

var awareness: float

var lvl: int = 1;
var exp: int = 0;

var visibleEnemies: Array[Mob]

func _init() -> void:
	super();
	name = "you";

	HP = 20
	HT = 20;
	STR = STARTING_STR;
	awareness = 0.1

	belongings = Belongings.new( self );

	visibleEnemies = []


func get_STR() -> int:
	return STR - 2 if weakened else STR


const ATTACK: String = "attackSkill"
const DEFENSE: String = "defenseSkill"
const STRENGTH: String = "STR"
const LEVEL: String = "lvl"
const EXPERIENCE: String = "exp"

#@Override
func storeInBundle(bundle: Bundle) -> void:
	super.storeInBundle( bundle );

	heroClass.storeInBundle( bundle );
	subClass.storeInBundle( bundle );

	bundle.put( ATTACK, attackSkill );
	bundle.put( DEFENSE, defenseSkill );

	bundle.put( STRENGTH, STR );

	bundle.put( LEVEL, lvl );
	bundle.put( EXPERIENCE, exp );

	belongings.storeInBundle( bundle );


#@Override
func restoreFromBundle(bundle: Bundle) -> void:
	super.restoreFromBundle( bundle );

	heroClass = HeroClass.restoreInBundle( bundle );
	subClass = HeroSubClass.restoreInBundle( bundle );

	attackSkill = bundle.getInt( ATTACK );
	defenseSkill = bundle.getInt( DEFENSE );

	STR = bundle.getInt( STRENGTH );
	updateAwareness();

	lvl = bundle.getInt( LEVEL );
	exp = bundle.getInt( EXPERIENCE );

	belongings.restoreFromBundle( bundle );


static func preview(info: GamesInProgress.Info, bundle: Bundle) -> void:
	info.level = bundle.getInt( LEVEL );


func className() -> String:
	return heroClass.title() if subClass == null || subClass == HeroSubClass.NONE else subClass.title();


func live() -> void:
	Buff.affect( this, Regeneration.class );
	Buff.affect( this, Hunger.class );


func tier() -> int:
	return 0 if belongings.armor == null else belongings.armor.tier;


func shoot(enemy: Char, wep: MissileWeapon) -> bool:

	rangedWeapon = wep;
	var result: bool = attack( enemy );
	rangedWeapon = null;

	return result;


#@Override
func get_attackSkill(target: Char) -> int:

	var bonus: int = 0;
	for buff: Buff in buffs( RingOfAccuracy.Accuracy.class ):
		bonus += (buff as RingOfAccuracy.Accuracy).level;

	var accuracy: float = 1 if bonus == 0 else pow( 1.4, bonus );
	if (rangedWeapon != null && Level.distance( pos, target.pos ) == 1):
		accuracy *= 0.5


	var wep: KindOfWeapon = rangedWeapon if rangedWeapon != null else belongings.weapon;
	if (wep != null):
		return attackSkill * accuracy * wep.acuracyFactor( this )
	else:
		return attackSkill * accuracy



#@Override
func get_defenseSkill(enemy: Char) -> int:

	var bonus: int = 0;
	for buff: Buff in buffs( RingOfEvasion.Evasion.class ):
		bonus += (buff as RingOfEvasion.Evasion).level;

	var evasion: float = 1 if bonus == 0 else pow( 1.2, bonus );
	if (paralysed):
		evasion /= 2;


	var aEnc: int = belongings.armor.STR - STR() if belongings.armor != null else 0;

	if (aEnc > 0):
		return (defenseSkill * evasion / Math.pow( 1.5, aEnc ));
	else:

		if (heroClass == HeroClass.ROGUE):

			if (curAction != null && subClass == HeroSubClass.FREERUNNER && !isStarving()):
				evasion *= 2;


			return (int)((defenseSkill - aEnc) * evasion);
		else:
			return (int)(defenseSkill * evasion);




#@Override
func dr() -> int:
	var dr: int = max( belongings.armor.DR(), 0 ) if belongings.armor != null else 0;
	var barkskin: Barkskin = buff( Barkskin.class );
	if (barkskin != null):
		dr += barkskin.level();

	return dr;


#@Override
func damageRoll() -> int:
	var wep: KindOfWeapon = rangedWeapon if rangedWeapon != null else belongings.weapon;
	var dmg: int
	if (wep != null):
		dmg = wep.damageRoll( this );
	else:
		dmg = Random.IntRange( 1, STR() - 9 ) if STR() > 10 else 1;

	return (dmg * 1.5) if buff( Fury.class ) != null else dmg;


#@Override
func speed() -> float:

	var aEnc: int = belongings.armor.STR - STR() if belongings.armor != null else 0;
	if (aEnc > 0):

		return (float)(super.speed() * Math.pow( 1.3, -aEnc ));

	else:

		var speed: float = super.speed();
		return 1.6 * speed if (sprite as HeroSprite).sprint( subClass == HeroSubClass.FREERUNNER && !isStarving() ) else speed;




func attackDelay() -> float:
	var wep: KindOfWeapon = rangedWeapon if rangedWeapon != null else belongings.weapon;
	if (wep != null):

		return wep.speedFactor( this );

	else:
		return 1



#@Override
func spend(time: float) -> void:
	var hasteLevel: int = 0;
	for buff: Buff in buffs( RingOfHaste.Haste.class ):
		hasteLevel += (buff as RingOfHaste.Haste).level;

	super.spend(time if hasteLevel == 0 else (time * Math.pow( 1.1, -hasteLevel )) );


func spendAndNext(time: float) -> void:
	busy();
	spend( time );
	next();


#@Override
func act() -> bool:

	super.act();

	if (paralysed):

		curAction = null;

		spendAndNext( TICK );
		return false;


	checkVisibleMobs();
	AttackIndicator.updateState();

	if (curAction == null):

		if (restoreHealth):
			if (isStarving() || HP >= HT):
				restoreHealth = false;
			else:
				spend( TIME_TO_REST ); next();
				return false;



		ready();
		return false;

	else:

		restoreHealth = false;

		ready = false;

		if (curAction is HeroAction.Move):
			return actMove(curAction as HeroAction.Move);

		elif (curAction is HeroAction.Interact):
			return actInteract(curAction as HeroAction.Interact);

		elif (curAction is HeroAction.Buy):
			return actBuy(curAction as HeroAction.Buy);

		elif (curAction is HeroAction.PickUp):
			return actPickUp(curAction as HeroAction.PickUp);

		elif (curAction is HeroAction.OpenChest):
			return actOpenChest(curAction as HeroAction.OpenChest);

		elif (curAction is HeroAction.Unlock):
			return actUnlock(curAction as HeroAction.Unlock);

		elif (curAction is HeroAction.Descend):
			return actDescend(curAction as HeroAction.Descend);

		elif (curAction is HeroAction.Ascend):
			return actAscend(curAction as HeroAction.Ascend);

		elif (curAction is HeroAction.Attack):
			return actAttack(curAction as HeroAction.Attack);

		elif (curAction is HeroAction.Cook):
			return actCook(curAction as HeroAction.Cook);

	return false;


func busy() -> void:
	ready = false;


func get_ready() -> void:
	sprite.idle();
	curAction = null;
	ready = true;

	GameScene.ready();


func interrupt() -> void:
	if (isAlive() && curAction != null && curAction.dst != pos):
		lastAction = curAction;

	curAction = null;


func resume() -> void:
	curAction = lastAction;
	lastAction = null;
	act();


func actMove(action: HeroAction.Move) -> bool:

	if (getCloser( action.dst )):

		return true;

	else:
		if (Dungeon.level.map[pos] == Terrain.SIGN):
			Sign.read( pos );

		ready();

		return false;



func actInteract(action: HeroAction.Interact) -> bool:

	var npc: NPC = action.npc;

	if (Level.adjacent( pos, npc.pos )):

		ready();
		sprite.turnTo( pos, npc.pos );
		npc.interact();
		return false;

	else:

		if (Level.fieldOfView[npc.pos] && getCloser( npc.pos )):

			return true;

		else:
			ready();
			return false;





func actBuy(action: HeroAction.Buy) -> bool:
	var dst: int = action.dst
	if (pos == dst || Level.adjacent( pos, dst )):

		ready();

		var heap: Heap = Dungeon.level.heaps.get( dst );
		if (heap != null && heap.type == Type.FOR_SALE && heap.size() == 1):
			GameScene.show(WndTradeItem.new( heap, true ) );


		return false;

	elif (getCloser( dst )):

		return true;

	else:
		ready();
		return false;



func actCook(action: HeroAction.Cook) -> bool:
	var dst: int = action.dst;
	if (Dungeon.visible[dst]):

		ready();
		AlchemyPot.operate( this, dst );
		return false;

	elif (getCloser( dst )):

		return true;

	else:
		ready();
		return false;



func actPickUp(action: HeroAction.PickUp) -> bool:
	var dst: int = action.dst;
	if (pos == dst):

		var heap: Heap = Dungeon.level.heaps.get( pos );
		if (heap != null):
			var item: Item = heap.pickUp();
			if (item.doPickUp( this )):

				if (item is Dewdrop):
					pass
				else:
					var important: bool = \
						((item is ScrollOfUpgrade || item is ScrollOfEnchantment) && (item as Scroll).isKnown()) || \
						((item is PotionOfStrength || item is PotionOfMight) && (item as Potion).isKnown());
					if (important):
						GLog.p( TXT_YOU_NOW_HAVE, item.name() );
					else:
						GLog.i( TXT_YOU_NOW_HAVE, item.name() );

				if (!heap.isEmpty()):
					GLog.i( TXT_SOMETHING_ELSE );

				curAction = null;
			else:
				Dungeon.level.drop( item, pos ).sprite.drop();
				ready();

		else:
			ready();

		return false;

	elif (getCloser( dst )):

		return true;
	else:
		ready();
		return false;



func actOpenChest(action: HeroAction.OpenChest) -> bool:
	var dst: int = action.dst;
	if (Level.adjacent( pos, dst ) || pos == dst):

		var heap: Heap = Dungeon.level.heaps.get( dst );
		if (heap != null && (heap.type != Type.HEAP && heap.type != Type.FOR_SALE)):

			theKey = null;

			if (heap.type == Type.LOCKED_CHEST || heap.type == Type.CRYSTAL_CHEST):

				theKey = belongings.getKey( GoldenKey.class, Dungeon.depth );

				if (theKey == null):
					GLog.w( TXT_LOCKED_CHEST );
					ready();
					return false;

			match (heap.type):
				TOMB:
					Sample.INSTANCE.play( Assets.SND_TOMB );
					Camera.main.shake( 1, 0.5 );

				SKELETON:
					pass
				_:
					Sample.INSTANCE.play( Assets.SND_UNLOCK );


			spend( Key.TIME_TO_UNLOCK );
			sprite.operate( dst );

		else:
			ready();


		return false;

	elif (getCloser( dst )):

		return true;

	else:
		ready();
		return false;



func actUnlock(action: HeroAction.Unlock) -> bool:
	var doorCell: int = action.dst;
	if (Level.adjacent( pos, doorCell )):

		theKey = null;
		var door: int = Dungeon.level.map[doorCell];

		if (door == Terrain.LOCKED_DOOR):

			theKey = belongings.getKey( IronKey.class, Dungeon.depth );

		elif (door == Terrain.LOCKED_EXIT):

			theKey = belongings.getKey( SkeletonKey.class, Dungeon.depth );



		if (theKey != null):

			spend( Key.TIME_TO_UNLOCK );
			sprite.operate( doorCell );

			Sample.INSTANCE.play( Assets.SND_UNLOCK );

		else:
			GLog.w( TXT_LOCKED_DOOR );
			ready();


		return false;

	elif (getCloser( doorCell )):

		return true;

	else:
		ready();
		return false;



func actDescend(action: HeroAction.Descend) -> bool:
	var stairs: int = action.dst;
	if (pos == stairs && pos == Dungeon.level.exit):

		curAction = null;

		var hunger: Hunger = buff( Hunger.class );
		if (hunger != null && !hunger.isStarving()):
			hunger.satisfy( -Hunger.STARVING / 10 );


		InterlevelScene.mode = InterlevelScene.Mode.DESCEND;
		Game.switchScene( InterlevelScene.class );

		return false;

	elif (getCloser( stairs )):

		return true;

	else:
		ready();
		return false;



func actAscend(action: HeroAction.Ascend) -> bool:
	var stairs: int = action.dst;
	if (pos == stairs && pos == Dungeon.level.entrance):

		if (Dungeon.depth == 1):

			if (belongings.getItem( Amulet.class ) == null):
				GameScene.show(WndMessage.new( TXT_LEAVE ) );
				ready();
			else:
				Dungeon.win( ResultDescriptions.WIN );
				Dungeon.deleteGame( Dungeon.hero.heroClass, true );
				Game.switchScene( SurfaceScene.class );


		else:

			curAction = null;

			var hunger: Hunger = buff( Hunger.class );
			if (hunger != null && !hunger.isStarving()):
				hunger.satisfy( -Hunger.STARVING / 10 );


			InterlevelScene.mode = InterlevelScene.Mode.ASCEND;
			Game.switchScene( InterlevelScene.class );


		return false;

	elif (getCloser( stairs )):

		return true;

	else:
		ready();
		return false;



func actAttack(action: HeroAction.Attack) -> bool:

	enemy = action.target;

	if (Level.adjacent( pos, enemy.pos ) && enemy.isAlive() && !isCharmedBy( enemy )):

		spend( attackDelay() );
		sprite.attack( enemy.pos );

		return false;

	else:

		if (Level.fieldOfView[enemy.pos] && getCloser( enemy.pos )):

			return true;

		else:
			ready();
			return false;





func rest(tillHealthy: bool) -> void:
	spendAndNext( TIME_TO_REST );
	if (!tillHealthy):
		sprite.showStatus( CharSprite.DEFAULT, TXT_WAIT );

	restoreHealth = tillHealthy;


#@Override
func attackProc(enemy: Char, damage: int) -> int:
	var wep: KindOfWeapon = rangedWeapon if rangedWeapon != null else belongings.weapon;
	if (wep != null):

		wep.proc( this, enemy, damage );

		match (subClass):
			GLADIATOR:
				if (wep is MeleeWeapon):
					damage += Buff.affect( this, Combo.class ).hit( enemy, damage );


			BATTLEMAGE:
				if (wep is Wand):
					var wand: Wand = wep as Wand
					if (wand.curCharges >= wand.maxCharges):

						wand.use();

					elif (damage > 0):

						wand.curCharges += 1
						wand.updateQuickslot();

						ScrollOfRecharging.charge( this );

					damage += wand.curCharges;

			SNIPER:
				if (rangedWeapon != null):
					Buff.prolong( this, SnipersMark.class, attackDelay() * 1.1 ).object = enemy.id();

	return damage;


#@Override
func defenseProc(enemy: Char, damage: int) -> int:

	var thorns: RingOfThorns.Thorns = buff( RingOfThorns.Thorns.class );
	if (thorns != null):
		var dmg: int = Random.IntRange( 0, damage );
		if (dmg > 0):
			enemy.damage( dmg, thorns );



	var armor: Earthroot.Armor = buff( Earthroot.Armor.class );
	if (armor != null):
		damage = armor.absorb( damage );


	if (belongings.armor != null):
		damage = belongings.armor.proc( enemy, this, damage );


	return damage;


#@Override
func damage(dmg: int, src: Object) -> void:
	restoreHealth = false;
	super.damage( dmg, src );

	if (subClass == HeroSubClass.BERSERKER && 0 < HP && HP <= HT * Fury.LEVEL):
		Buff.affect( this, Fury.class );



func checkVisibleMobs() -> void:
	var visible: Array[Mob] = []

	var newMob: bool = false;

	for m: Mob in Dungeon.level.mobs:
		if (Level.fieldOfView[ m.pos ] && m.hostile):
			visible.add( m );
			if (!visibleEnemies.contains( m )):
				newMob = true;

	if (newMob):
		interrupt();
		restoreHealth = false;

	visibleEnemies = visible;


func get_visibleEnemies() -> int:
	return visibleEnemies.size();


func visibleEnemy(index: int) -> Mob:
	return visibleEnemies.get( index % visibleEnemies.size() );


func getCloser(target: int) -> bool:

	if (rooted):
		Camera.main.shake( 1, 1);
		return false;


	var step: int = -1;

	if (Level.adjacent( pos, target )):

		if (Actor.findChar( target ) == null):
			if (Level.pit[target] && !flying && !Chasm.jumpConfirmed):
				Chasm.heroJump( this );
				interrupt();
				return false;

			if (Level.passable[target] || Level.avoid[target]):
				step = target;



	else:

		var len: int = Level.LENGTH;
		var p: Array[bool] = Level.passable;
		var v: Array[bool] = Dungeon.level.visited;
		var m: Array[bool] = Dungeon.level.mapped;
		var passable: Array[bool] = []
		passable.resize(len)
		for i: int in range(len):
			passable[i] = p[i] && (v[i] || m[i]);


		step = Dungeon.findPath( this, pos, target, passable, Level.fieldOfView );


	if (step != -1):

		var oldPos: int = pos;
		move( step );
		sprite.move( oldPos, pos );
		spend( 1 / speed() );

		return true;

	else:

		return false;





func handle(cell: int) -> bool:

	if (cell == -1):
		return false;


	var ch: Char
	var heap: Heap

	if (Dungeon.level.map[cell] == Terrain.ALCHEMY && cell != pos):

		curAction = HeroAction.Cook.new( cell );


	elif (Level.fieldOfView[cell] && (Actor.findChar( cell )) is Mob):
		ch = Actor.findChar( cell )

		if (ch is NPC):
			curAction = HeroAction.Interact.new(ch as NPC);
		else:
			curAction = HeroAction.Attack.new( ch );


	elif (Level.fieldOfView[cell] && (Dungeon.level.heaps.get( cell )) != null && heap.type != Heap.Type.HIDDEN):
		heap = Dungeon.level.heaps.get( cell )
		match (heap.type):
			HEAP:
				curAction = HeroAction.PickUp.new( cell );

			FOR_SALE:
				curAction = HeroAction.Buy.new( cell ) if heap.size() == 1 && heap.peek().price() > 0 else HeroAction.PickUp.new( cell );

			_:
				curAction = HeroAction.OpenChest.new( cell );


	elif (Dungeon.level.map[cell] == Terrain.LOCKED_DOOR || Dungeon.level.map[cell] == Terrain.LOCKED_EXIT):
		curAction = HeroAction.Unlock.new( cell );

	elif (cell == Dungeon.level.exit):
		curAction = HeroAction.Descend.new( cell );

	elif (cell == Dungeon.level.entrance):
		curAction = HeroAction.Ascend.new( cell );

	else:
		curAction = HeroAction.Move.new( cell );
		lastAction = null;

	return act();


func earnExp(exp: int) -> void:

	this.exp += exp;

	var levelUp: bool = false;
	while (this.exp >= maxExp()):
		this.exp -= maxExp();
		lvl += 1

		HT += 5;
		HP += 5;
		attackSkill += 1
		defenseSkill += 1

		if (lvl < 10):
			updateAwareness();


		levelUp = true;


	if (levelUp):

		GLog.p( TXT_NEW_LEVEL, lvl );
		sprite.showStatus( CharSprite.POSITIVE, TXT_LEVEL_UP );
		Sample.INSTANCE.play( Assets.SND_LEVELUP );

		Badges.validateLevelReached();


	if (subClass == HeroSubClass.WARLOCK):

		var value: int = min( HT - HP, 1 + (Dungeon.depth - 1) / 5 );
		if (value > 0):
			HP += value;
			sprite.emitter().burst( Speck.factory( Speck.HEALING ), 1 );


		(buff( Hunger.class ) as Hunger).satisfy( 10 );



func maxExp() -> int:
	return 5 + lvl * 5;


func updateAwareness() -> void:
	awareness = 1 - pow((0.85 if heroClass == HeroClass.ROGUE else 0.90), (1 + min( lvl, 9 )) * 0.5)


func isStarving() -> bool:
	return (buff( Hunger.class ) as Hunger).isStarving();


#@Override
func add(buff: Buff) -> void:
	super.add( buff );

	if (sprite != null):
		if (buff is Burning):
			GLog.w( "You catch fire!" );
			interrupt();
		elif (buff is Paralysis):
			GLog.w( "You are paralysed!" );
			interrupt();
		elif (buff is Poison):
			GLog.w( "You are poisoned!" );
			interrupt();
		elif (buff is Ooze):
			GLog.w( "Caustic ooze eats your flesh. Wash away it!" );
		elif (buff is Roots):
			GLog.w( "You can't move!" );
		elif (buff is Weakness):
			GLog.w( "You feel weakened!" );
		elif (buff is Blindness):
			GLog.w( "You are blinded!" );
		elif (buff is Fury):
			GLog.w( "You become furious!" );
			sprite.showStatus( CharSprite.POSITIVE, "furious" );
		elif (buff is Charm):
			GLog.w( "You are charmed!" );
		elif (buff is Cripple):
			GLog.w( "You are crippled!" );
		elif (buff is Bleeding):
			GLog.w( "You are bleeding!" );
		elif (buff is Vertigo):
			GLog.w( "Everything is spinning around you!" );
			interrupt();
		elif (buff is Light):
			sprite.add( CharSprite.State.ILLUMINATED );

	BuffIndicator.refreshHero();


#@Override
func remove(buff: Buff) -> void:
	super.remove( buff );

	if (buff is Light):
		sprite.remove( CharSprite.State.ILLUMINATED );

	BuffIndicator.refreshHero();


#@Override
func stealth() -> int:
	var stealth: int = super.stealth();
	for buff: Buff in buffs( RingOfShadows.Shadows.class ):
		stealth += (buff as RingOfShadows.Shadows).level;

	return stealth;


#@Override
func die(cause: Object) -> void:

	curAction = null;

	DewVial.autoDrink( this );
	if (isAlive()):
		Flare.new( 8, 32 ).color( 0xFFFF66, true ).show( sprite, 2 ) ;
		return;


	Actor.fixTime();
	super.die( cause );

	var ankh: Ankh = belongings.getItem( Ankh.class ) as Ankh
	if (ankh == null):

		reallyDie( cause );

	else:

		Dungeon.deleteGame( Dungeon.hero.heroClass, false );
		GameScene.show(WndResurrect.new( ankh, cause ) );




static func reallyDie(cause: Object) -> void:

	var length: int = Level.LENGTH;
	var map: PackedInt32Array = Dungeon.level.map;
	var visited: Array[bool] = Dungeon.level.visited;
	var discoverable: Array[bool] = Level.discoverable;

	for i: int in range(length):

		var terr: int = map[i];

		if (discoverable[i]):

			visited[i] = true;
			if ((Terrain.flags[terr] & Terrain.SECRET) != 0):
				Level.set( i, Terrain.discover( terr ) );
				GameScene.updateMap( i );

	Bones.leave();

	Dungeon.observe();

	Dungeon.hero.belongings.identify();

	var pos: int = Dungeon.hero.pos;

	var passable: PackedInt32Array = []
	for ofs: int in Level.NEIGHBOURS8:
		var cell: int = pos + ofs;
		if ((Level.passable[cell] || Level.avoid[cell]) && Dungeon.level.heaps.get( cell ) == null):
			passable.add( cell );


	Collections.shuffle( passable );

	var items: Array[Item] = Dungeon.hero.belongings.backpack.items
	for  cell: int in  passable:
		if (items.isEmpty()):
			break;


		var item: Item = Random.element( items );
		Dungeon.level.drop( item, cell ).sprite.drop( pos );
		items.remove( item );


	GameScene.gameOver();

	if (cause is Hero.Doom):
		(cause as Hero.Doom).onDeath();


	Dungeon.deleteGame( Dungeon.hero.heroClass, true );


#@Override
func move(step: int) -> void:
	super.move( step );

	if (!flying):

		if (Level.water[pos]):
			Sample.INSTANCE.play( Assets.SND_WATER, 1, 1, Random.Float( 0.8, 1.25 ) );
		else:
			Sample.INSTANCE.play( Assets.SND_STEP );

		Dungeon.level.press( pos, this );



#@Override
func onMotionComplete() -> void:
	Dungeon.observe();
	search( false );

	super.onMotionComplete();


#@Override
func onAttackComplete() -> void:

	AttackIndicator.target( enemy );

	attack( enemy );
	curAction = null;

	Invisibility.dispel();

	super.onAttackComplete();


#@Override
func onOperateComplete() -> void:

	if (curAction is HeroAction.Unlock):

		if (theKey != null):
			theKey.detach( belongings.backpack );
			theKey = null;


		var doorCell: int = (curAction as HeroAction.Unlock).dst;
		var door: int = Dungeon.level.map[doorCell];

		Level.set( doorCell, Terrain.DOOR if door == Terrain.LOCKED_DOOR else Terrain.UNLOCKED_EXIT );
		GameScene.updateMap( doorCell );

	elif (curAction is HeroAction.OpenChest):

		if (theKey != null):
			theKey.detach( belongings.backpack );
			theKey = null;


		var heap: Heap = Dungeon.level.heaps.get( (curAction as HeroAction.OpenChest).dst );
		if (heap.type == Type.SKELETON):
			Sample.INSTANCE.play( Assets.SND_BONES );

		heap.open( this );

	curAction = null;

	super.onOperateComplete();


func search(intentional: bool) -> bool:

	var smthFound: bool = false;

	var positive: int = 0;
	var negative: int = 0;
	for buff: Buff in buffs( RingOfDetection.Detection.class ):
		var bonus: int = (buff as RingOfDetection.Detection).level;
		if (bonus > positive):
			positive = bonus;
		elif (bonus < 0):
			negative += bonus;


	var distance: int = 1 + positive + negative;

	var level: float = (2 * awareness - awareness * awareness) if intentional else awareness;
	if (distance <= 0):
		level /= 2 - distance;
		distance = 1;


	var cx: int = pos % Level.WIDTH;
	var cy: int = pos / Level.WIDTH;
	var ax: int = cx - distance;
	if (ax < 0):
		ax = 0;

	var bx: int = cx + distance;
	if (bx >= Level.WIDTH):
		bx = Level.WIDTH - 1;

	var ay: int = cy - distance;
	if (ay < 0):
		ay = 0;

	var by: int = cy + distance;
	if (by >= Level.HEIGHT):
		by = Level.HEIGHT - 1;


	for y: int in range(ay, by):
		p = ax + y * Level.WIDTH
		for x: int in range(ax, bx):
			p += 1

			if (Dungeon.visible[p]):

				if (intentional):
					sprite.parent.addToBack(CheckedCell.new( p ) );


				if (Level.secret[p] && (intentional || Random.Float() < level)):

					var oldValue: int = Dungeon.level.map[p];

					GameScene.discoverTile( p, oldValue );

					Level.set( p, Terrain.discover( oldValue ) );

					GameScene.updateMap( p );

					ScrollOfMagicMapping.discover( p );

					smthFound = true;


				if (intentional):
					var heap: Heap = Dungeon.level.heaps.get( p );
					if (heap != null && heap.type == Type.HIDDEN):
						heap.open( this );
						smthFound = true;

	if (intentional):
		sprite.showStatus( CharSprite.DEFAULT, TXT_SEARCH );
		sprite.operate( pos );
		if (smthFound):
			spendAndNext(TIME_TO_SEARCH if Random.Float() < level else TIME_TO_SEARCH * 2 );
		else:
			spendAndNext( TIME_TO_SEARCH );




	if (smthFound):
		GLog.w( TXT_NOTICED_SMTH );
		Sample.INSTANCE.play( Assets.SND_SECRET );
		interrupt();


	return smthFound;


func resurrect(resetLevel: int) -> void:

	HP = HT;
	Dungeon.gold = 0;
	exp = 0;

	belongings.resurrect( resetLevel );

	live();


#@Override
func resistances() -> Array:
	var r: RingOfElements.Resistance = buff( RingOfElements.Resistance.class );
	return r == super.resistances() if null else r.resistances();


#@Override
func immunities() -> Array:
	var buff: GasesImmunity = buff( GasesImmunity.class );
	return buff == super.immunities() if null else GasesImmunity.IMMUNITIES;


#@Override
func next() -> void:
	super.next();
