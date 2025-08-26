@abstract class_name Actor
extends Bundlable

const TICK: float = 1

var time: float

var id: int = 0;

@abstract func act() -> bool

func spend(time: float) -> void:
	this.time += time;


func postpone(time: float) -> void:
	if (self.time < now + time):
		self.time = now + time;



func cooldown() -> float:
	return time - now;


func diactivate() -> void:
	time = Float.MAX_VALUE;


func onAdd() -> void:
	pass

func onRemove() -> void:
	pass

const TIME: String = "time";
const ID: String = "id";

#@Override
func storeInBundle(bundle: Bundle) -> void:
	bundle.put( TIME, time );
	bundle.put( ID, id );


#@Override
func restoreFromBundle(bundle: Bundle) -> void:
	time = bundle.getFloat( TIME );
	id = bundle.getInt( ID );


func get_id() -> int:
	if (id > 0):
		return id;
	else:
		var max: int = 0;
		for a: Actor in all:
			if (a.id > max):
				max = a.id;

		id = max + 1
		return id



# **********************
# *** Static members ***

static var all: Array[Actor] = []
static var current: Actor

static var ids: Array[Actor] = []

static var now: float = 0;

static var chars: Array[Char] = []
#chars.resize(Level.LENGTH)

static func clear() -> void:

	now = 0;

	Arrays.fill( chars, null );
	all.clear();

	ids.clear();


static func fixTime() -> void:

	if (Dungeon.hero != null && all.contains( Dungeon.hero )):
		Statistics.duration += now;


	var min: float = Float.MAX_VALUE;
	for a: Actor in all:
		if (a.time < min):
			min = a.time;


	for a: Actor in all:
		a.time -= min;

	now = 0;


static func init() -> void:

	addDelayed( Dungeon.hero, -Float.MIN_VALUE );

	for mob: Mob in Dungeon.level.mobs:
		add( mob );


	for blob: Blob in Dungeon.level.blobs.values():
		add( blob );


	current = null;


static func occupyCell(ch: Char) -> void:
	chars[ch.pos] = ch;


static func freeCell(pos: int) -> void:
	chars[pos] = null;


func next() -> void:
	if (current == this):
		current = null;



static func process() -> void:

	if (current != null):
		return;


	var doNext: bool = true

	while (doNext):
		now = Float.MAX_VALUE;
		current = null;

		Arrays.fill( chars, null );

		for actor: Actor in all:
			if (actor.time < now):
				now = actor.time;
				current = actor;


			if (actor is Char):
				var ch: Char = actor as Char
				chars[ch.pos] = ch;



		if (current != null):

			if (current is Char && (current as Char).sprite.isMoving):
				# If it's character's turn to act, but its sprite
				# is moving, wait till the movement is over
				current = null;
				break;


			doNext = current.act();
			if (doNext && !Dungeon.hero.isAlive()):
				doNext = false;
				current = null;

		else:
			doNext = false;



static func add(actor: Actor) -> void:
	add( actor, now );


static func addDelayed(actor: Actor, delay: float) -> void:
	add( actor, now + delay );


static func add_time( actor: Actor, time: float) -> void:

	if (all.contains( actor )):
		return;


	if (actor.id > 0):
		ids.put( actor.id,  actor );


	all.add( actor );
	actor.time += time;
	actor.onAdd();

	if (actor is Char):
		var ch: Char = actor as Char
		chars[ch.pos] = ch;
		for buff: Buff in ch.buffs():
			all.add( buff );
			buff.onAdd();




static func remove(actor: Actor) -> void:

	if (actor != null):
		all.remove( actor );
		actor.onRemove();

		if (actor.id > 0):
			ids.remove( actor.id );




static func findChar(pos: int) -> Char:
	return chars[pos];


static func findById(id: int) -> Actor:
	return ids.get( id );


static func get_all() -> Array[Actor]:
	return all;
