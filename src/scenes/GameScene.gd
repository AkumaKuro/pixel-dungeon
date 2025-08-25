class_name GameScene
extends PixelScene


const TXT_WELCOME: String			= "Welcome to the level %d of Pixel Dungeon!";
const TXT_WELCOME_BACK: String	= "Welcome back to the level %d of Pixel Dungeon!";
const TXT_NIGHT_MODE: String		= "Be cautious, since the dungeon is even more dangerous at night!";

const TXT_CHASM: String	= "Your steps echo across the dungeon.";
const TXT_WATER: String	= "You hear the water splashing around you.";
const TXT_GRASS: String	= "The smell of vegetation is thick in the air.";
const TXT_SECRETS: String	= "The atmosphere hints that this floor hides many secrets.";

static var scene: GameScene

var water: SkinnedBlock
var tiles: DungeonTilemap
var fog: FogOfWar
var hero: HeroSprite

var log: GameLog

var busy: BusyIndicator

static var cellSelector: CellSelector

var terrain: Group
var ripples: Group
var plants: Group
var heaps: Group
var mobs: Group
var emitters: Group
var effects: Group
var gases: Group
var spells: Group
var statuses: Group
var emoicons: Group

var toolbar: Toolbar
var prompt: Toast

const defaultCellListener: CellSelector.Listener = CellSelector.Listener.new()

func _init():
	defaultCellListener.onSelect.bind(
	func(cell: int):
		if (Dungeon.hero.handle( cell )):
			Dungeon.hero.next();
	)

	defaultCellListener.prompt.bind(
		func():
			return null;
	)

#@Override
func create() -> void:
	Music.INSTANCE.play( Assets.TUNE, true );
	Music.INSTANCE.volume( 1 );

	PixelDungeon.lastClass( Dungeon.hero.heroClass.ordinal() );

	super.create();
	Camera.main.zoom( defaultZoom + PixelDungeon.zoom() );

	scene = this;

	terrain = Group.new();
	add( terrain );

	water = SkinnedBlock.new(
		Level.WIDTH * DungeonTilemap.SIZE,
		Level.HEIGHT * DungeonTilemap.SIZE,
		Dungeon.level.waterTex() );
	terrain.add( water );

	ripples = Group.new();
	terrain.add( ripples );

	tiles = DungeonTilemap.new();
	terrain.add( tiles );

	Dungeon.level.addVisuals( this );

	plants = Group.new();
	add( plants );

	var size: int = Dungeon.level.plants.size();
	for i: int in range(size):
		addPlantSprite( Dungeon.level.plants.valueAt( i ) );


	heaps = Group.new();
	add( heaps );

	size = Dungeon.level.heaps.size();
	for i: int in range(size):
		addHeapSprite( Dungeon.level.heaps.valueAt( i ) );


	emitters = Group.new();
	effects = Group.new();
	emoicons = Group.new();

	mobs = Group.new();
	add( mobs );

	for mob: Mob in Dungeon.level.mobs:
		addMobSprite( mob );
		if (Statistics.amuletObtained):
			mob.beckon( Dungeon.hero.pos );



	add( emitters );
	add( effects );

	gases = Group.new();
	add( gases );

	for blob: Blob in Dungeon.level.blobs.values():
		blob.emitter = null;
		addBlobSprite( blob );


	fog = FogOfWar.new( Level.WIDTH, Level.HEIGHT );
	fog.updateVisibility( Dungeon.visible, Dungeon.level.visited, Dungeon.level.mapped );
	add( fog );

	brightness( PixelDungeon.brightness() );

	spells = Group.new();
	add( spells );

	statuses = Group.new();
	add( statuses );

	add( emoicons );

	hero = HeroSprite.new();
	hero.place( Dungeon.hero.pos );
	hero.updateArmor();
	mobs.add( hero );

	add( HealthIndicator.new() );

	cellSelector = CellSelector.new( tiles )
	add(cellSelector);

	var sb: StatusPane = StatusPane.new();
	sb.camera = uiCamera;
	sb.setSize( uiCamera.width, 0 );
	add( sb );

	toolbar = Toolbar.new();
	toolbar.camera = uiCamera;
	toolbar.setRect( 0,uiCamera.height - toolbar.height(), uiCamera.width, toolbar.height() );
	add( toolbar );

	var attack: AttackIndicator = AttackIndicator.new();
	attack.camera = uiCamera;
	attack.setPos(
		uiCamera.width - attack.width(),
		toolbar.top() - attack.height() );
	add( attack );

	log = GameLog.new();
	log.camera = uiCamera;
	log.setRect( 0, toolbar.top(), attack.left(),  0 );
	add( log );

	busy = BusyIndicator.new();
	busy.camera = uiCamera;
	busy.x = 1;
	busy.y = sb.bottom() + 1;
	add( busy );

	match InterlevelScene.mode:
		RESURRECT:
			WandOfBlink.appear( Dungeon.hero, Dungeon.level.entrance );
			Flare.new( 8, 32 ).color( 0xFFFF66, true ).show( hero, 2)

		RETURN:
			WandOfBlink.appear(  Dungeon.hero, Dungeon.hero.pos );

		FALL:
			Chasm.heroLand();

		DESCEND:
			match Dungeon.depth:
				1:
					WndStory.showChapter( WndStory.ID_SEWERS );

				6:
					WndStory.showChapter( WndStory.ID_PRISON );

				11:
					WndStory.showChapter( WndStory.ID_CAVES );

				16:
					WndStory.showChapter( WndStory.ID_METROPOLIS );

				22:
					WndStory.showChapter( WndStory.ID_HALLS );


			if (Dungeon.hero.isAlive() && Dungeon.depth != 22):
				Badges.validateNoKilling();

	var dropped: ArrayList[Item] = Dungeon.droppedItems.get( Dungeon.depth );
	if (dropped != null):
		for item: Item in dropped:
			var pos: int = Dungeon.level.randomRespawnCell();
			if (item is Potion):
				(item as Potion).shatter( pos );
			elif (item is Plant.Seed):
				Dungeon.level.plant(item as Plant.Seed, pos );
			else:
				Dungeon.level.drop( item, pos );


		Dungeon.droppedItems.remove( Dungeon.depth );


	Camera.main.target = hero;

	if (InterlevelScene.mode != InterlevelScene.Mode.NONE):
		if (Dungeon.depth < Statistics.deepestFloor):
			GLog.h( TXT_WELCOME_BACK, Dungeon.depth );
		else:
			GLog.h( TXT_WELCOME, Dungeon.depth );
			Sample.INSTANCE.play( Assets.SND_DESCEND );

		match Dungeon.level.feeling:
			CHASM:
				GLog.w( TXT_CHASM );

			WATER:
				GLog.w( TXT_WATER );

			GRASS:
				GLog.w( TXT_GRASS );


		if (Dungeon.level is RegularLevel &&
				(Dungeon.level as RegularLevel).secretDoors > Random.IntRange( 3, 4 )):
			GLog.w( TXT_SECRETS );

		if (Dungeon.nightMode && !Dungeon.bossLevel()):
			GLog.w( TXT_NIGHT_MODE );


		InterlevelScene.mode = InterlevelScene.Mode.NONE;

		fadeIn();



func destroy() -> void:

	scene = null;
	Badges.saveGlobal();

	super.destroy();


#@Override
#async
func pause() -> void:
	Dungeon.saveAll();
	Badges.saveGlobal();



#@Override
#async
func update() -> void:
	if (Dungeon.hero == null):
		return;


	super.update();

	water.offset( 0, -5 * Game.elapsed );

	Actor.process();

	if (Dungeon.hero.ready && !Dungeon.hero.paralysed):
		log.newLine();


	cellSelector.enabled = Dungeon.hero.ready;


#@Override
func onBackPressed() -> void:
	if (!cancel()):
		add(WndGame.new() );



#@Override
func onMenuPressed() -> void:
	if (Dungeon.hero.ready):
		selectItem( null, WndBag.Mode.ALL, null );



func brightness(value: bool) -> void:
	var b = 1.5 if value else 1.0
	water.rm = b
	water.gm = b
	water.bm = b
	tiles.rm = b
	tiles.gm = b
	tiles.bm = b
	if (value):
		fog.am = +2
		fog.aa = -1
	else:
		fog.am = +1
		fog.aa =  0



func addHeapSprite(heap: Heap) -> void:
	var sprite: ItemSprite = heaps.recycle( ItemSprite.class ) as ItemSprite
	heap.sprite = sprite
	sprite.revive();
	sprite.link( heap );
	heaps.add( sprite );


func addDiscardedSprite(heap: Heap) -> void:
	heap.sprite = heaps.recycle( DiscardedItemSprite.class ) as DiscardedItemSprite
	heap.sprite.revive();
	heap.sprite.link( heap );
	heaps.add( heap.sprite );


func addPlantSprite(plant: Plant) -> void:
	plant.sprite = plants.recycle( PlantSprite.class ) as PlantSprite
	plant.sprite.reset( plant );


func addBlobSprite(gas: Blob) -> void:
	if (gas.emitter == null):
		gases.add(BlobEmitter.new( gas ) );



func addMobSprite(mob: Mob) -> void:
	var sprite: CharSprite = mob.sprite();
	sprite.visible = Dungeon.visible[mob.pos];
	mobs.add( sprite );
	sprite.link( mob );


func prompt_f(text: String) -> void:

	if (prompt != null):
		prompt.killAndErase();
		prompt = null;


	if (text != null):
		prompt = Toast.new( text )

		prompt.onClose.bind(
			func():
				cancel();
		)

		prompt.camera = uiCamera
		prompt.setPos( (uiCamera.width - prompt.width()) / 2, uiCamera.height - 60 );
		add( prompt );



func showBanner(banner: Banner) -> void:
	banner.camera = uiCamera;
	banner.x = align( uiCamera, (uiCamera.width - banner.width) / 2 );
	banner.y = align( uiCamera, (uiCamera.height - banner.height) / 3 );
	add( banner );



static func add_plant(plant: Plant) -> void:
	if (scene != null):
		scene.addPlantSprite( plant );



static func add_blob(gas: Blob) -> void:
	Actor.add( gas );
	if (scene != null):
		scene.addBlobSprite( gas );



static func add_heap(heap: Heap) -> void:
	if (scene != null):
		scene.addHeapSprite( heap );



static func discard(heap: Heap) -> void:
	if (scene != null):
		scene.addDiscardedSprite( heap );



static func add_mob(mob: Mob) -> void:
	Dungeon.level.mobs.add( mob );
	Actor.add( mob );
	Actor.occupyCell( mob );
	scene.addMobSprite( mob );


static func add_mob_delay(mob: Mob, delay: float) -> void:
	Dungeon.level.mobs.add( mob );
	Actor.addDelayed( mob, delay );
	Actor.occupyCell( mob );
	scene.addMobSprite( mob );


static func add_emoicon(icon: EmoIcon) -> void:
	scene.emoicons.add( icon );


static func effect(effect: Visual) -> void:
	scene.effects.add( effect );


static func ripple(pos: int) -> Ripple:
	var ripple: Ripple = scene.ripples.recycle( Ripple.class ) as Ripple
	ripple.reset( pos );
	return ripple;


static func spellSprite() -> SpellSprite:
	return scene.spells.recycle( SpellSprite.class ) as SpellSprite


static func emitter() -> Emitter:
	if (scene != null):
		var emitter: Emitter = scene.emitters.recycle( Emitter.class ) as Emitter
		emitter.revive();
		return emitter;
	else:
		return null;



static func status() -> FloatingText:
	return scene.statuses.recycle( FloatingText.class ) as FloatingText if scene != null else null;


static func pickUp(item: Item) -> void:
	scene.toolbar.pickup( item );


static func updateMap() -> void:
	if (scene != null):
		scene.tiles.updated.set( 0, 0, Level.WIDTH, Level.HEIGHT );



static func updateMap_cell(cell: int) -> void:
	if (scene != null):
		scene.tiles.updated.union( cell % Level.WIDTH, cell / Level.WIDTH );



static func discoverTile(pos: int, oldValue: int) -> void:
	if (scene != null):
		scene.tiles.discover( pos, oldValue );



static func show(wnd: Window) -> void:
	cancelCellSelector();
	scene.add( wnd );


static func afterObserve() -> void:
	if (scene != null):
		scene.fog.updateVisibility( Dungeon.visible, Dungeon.level.visited, Dungeon.level.mapped );

		for mob: Mob in Dungeon.level.mobs:
			mob.sprite.visible = Dungeon.visible[mob.pos];




static func flash(color: int) -> void:
	scene.fadeIn( 0xFF000000 | color, true );


static func gameOver() -> void:
	var gameOver: Banner = Banner.new( BannerSprites.get( BannerSprites.Type.GAME_OVER ) );
	gameOver.show(0x000000, 1);
	scene.showBanner( gameOver );

	Sample.INSTANCE.play( Assets.SND_DEATH );


static func bossSlain() -> void:
	if (Dungeon.hero.isAlive()):
		var bossSlain: Banner = Banner.new( BannerSprites.get( BannerSprites.Type.BOSS_SLAIN ) );
		bossSlain.show( 0xFFFFFF, 0.3, 5 );
		scene.showBanner( bossSlain );

		Sample.INSTANCE.play( Assets.SND_BOSS );



static func handleCell(cell: int) -> void:
	cellSelector.select( cell );


static func selectCell(listener: CellSelector.Listener) -> void:
	cellSelector.listener = listener;
	scene.prompt( listener.prompt() );


static func cancelCellSelector() -> bool:
	if (cellSelector.listener != null && cellSelector.listener != defaultCellListener):
		cellSelector.cancel();
		return true;
	else:
		return false;



static func selectItem(listener: WndBag.Listener, mode: WndBag.Mode, title: String) -> WndBag:
	cancelCellSelector();

	var wnd: WndBag = WndBag.seedPouch( listener, mode, title ) if mode == Mode.SEED else WndBag.lastBag( listener, mode, title );
	scene.add( wnd );

	return wnd;


static func cancel() -> bool:
	if (Dungeon.hero.curAction != null || Dungeon.hero.restoreHealth):

		Dungeon.hero.curAction = null;
		Dungeon.hero.restoreHealth = false;
		return true;

	else:

		return cancelCellSelector();




static func ready() -> void:
	selectCell( defaultCellListener );
	QuickSlot.cancel();
