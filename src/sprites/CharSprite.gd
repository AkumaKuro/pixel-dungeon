class_name CharSprite
extends MovieClip #implements Tweener.Listener, MovieClip.Listener {

const DEFAULT: int = 0xFFFFFF;
const POSITIVE: int = 0x00FF00;
const NEGATIVE: int = 0xFF0000;
const WARNING: int = 0xFF8800;
const NEUTRAL: int = 0xFFFF00;

const MOVE_INTERVAL: float = 0.1
const FLASH_INTERVAL: float = 0.05

enum State {
	BURNING, LEVITATING, INVISIBLE, PARALYSED, FROZEN, ILLUMINATED
}

var idle: Animation
var run: Animation
var attack: Animation
var operate: Animation
var zap: Animation
var die_anim: Animation

var animCallback: Callback

var motion: Tweener

var burning: Emitter
var levitation: Emitter

var iceBlock: IceBlock
var halo: TorchHalo

var emo: EmoIcon

var jumpTweener: Tweener
var jumpCallback: Callback

var flashTime: float = 0;

var sleeping: bool = false;

var ch: Char

var isMoving: bool = false;

func _init() -> void:
	super();
	listener = self


func link(ch: Char) -> void:
	self.ch = ch;
	ch.sprite = self;

	place( ch.pos );
	turnTo( ch.pos, Random.Int( Level.LENGTH ) );

	ch.updateSpriteState();


func worldToCamera(cell: int) -> PointF:

	var csize: int = DungeonTilemap.SIZE;

	return PointF.new(
		((cell % Level.WIDTH) + 0.5) * csize - width * 0.5,
		((cell / Level.WIDTH) + 1.0) * csize - height
	);


func place(cell: int) -> void:
	point( worldToCamera( cell ) );


func showStatus(color: int, text: String, args: Array[Object]) -> void:
	if (visible):
		if (args.length > 0):
			text = Utils.format( text, args );

		if (ch != null):
			FloatingText.show( x + width * 0.5, y, ch.pos, text, color );
		else:
			FloatingText.show( x + width * 0.5, y, text, color );




func get_idle() -> void:
	play( idle );


func move(from: int,to: int ) -> void:
	play( run );

	motion = PosTweener.new( self, worldToCamera( to ), MOVE_INTERVAL );
	motion.listener = self;
	parent.add( motion );

	isMoving = true;

	turnTo( from , to );

	if (visible && Level.water[from] && !ch.flying):
		GameScene.ripple( from );


	ch.onMotionComplete();


func interruptMotion() -> void:
	if (motion != null):
		onComplete( motion );



func attack_cell(cell: int ) -> void:
	turnTo( ch.pos, cell );
	play( attack );


func attack_f(cell: int, callback: Callback) -> void:
	animCallback = callback;
	turnTo( ch.pos, cell );
	play( attack );


func operate_cell(cell: int ) -> void:
	turnTo( ch.pos, cell );
	play( operate );


func zap_cell(cell: int ) -> void:
	turnTo( ch.pos, cell );
	play( zap );


func turnTo(from: int,to: int ) -> void:
	var fx: int = from % Level.WIDTH;
	var tx: int = to % Level.WIDTH;
	if (tx > fx):
		flipHorizontal = false;
	elif (tx < fx):
		flipHorizontal = true;



func jump(from: int,to: int, callback: Callback) -> void:
	jumpCallback = callback;

	var distance: int = Level.distance( from, to );
	jumpTweener = JumpTweener.new( this, worldToCamera( to ), distance * 4, distance * 0.1 )
	jumpTweener.listener = this;
	parent.add( jumpTweener );

	turnTo( from, to );


func die() -> void:
	sleeping = false;
	play( die );

	if (emo != null):
		emo.killAndErase();



func emitter() -> Emitter:
	var emitter: Emitter = GameScene.emitter();
	emitter.pos( this );
	return emitter;


func centerEmitter() -> Emitter:
	var emitter: Emitter = GameScene.emitter();
	emitter.pos( center() );
	return emitter;


func bottomEmitter() -> Emitter:
	var emitter: Emitter = GameScene.emitter();
	emitter.pos( x, y + height, width, 0 );
	return emitter;


func burst(color: int, n: int) -> void:
	if (visible):
		Splash.at( center(), color, n );



func bloodBurstA(from: PointF, damage: int) -> void:
	if (visible):
		var c: PointF = center();
		var n: int = min( 9 * sqrt( damage / ch.HT ), 9 );
		Splash.at( c, PointF.angle( from, c ), PI / 2, blood(), n );



func blood() -> int:
	return 0xFFBB0000;


func flash() -> void:
	ra = 1
	ba = 1
	ga = 1
	flashTime = FLASH_INTERVAL;


func add(state: State) -> void:
	match state:
		BURNING:
			burning = emitter();
			burning.pour( FlameParticle.FACTORY, 0.06 );
			if (visible):
				Sample.INSTANCE.play( Assets.SND_BURNING );


		LEVITATING:
			levitation = emitter();
			levitation.pour( Speck.factory( Speck.JET ), 0.02 );

		INVISIBLE:
			PotionOfInvisibility.melt( ch );

		PARALYSED:
			paused = true;

		FROZEN:
			iceBlock = IceBlock.freeze( this );
			paused = true;

		ILLUMINATED:
			halo = TorchHalo.new( this )
			GameScene.effect( halo );




func remove(state: State) -> void:
	match state:
		BURNING:
			if (burning != null):
				burning.on = false;
				burning = null;


		LEVITATING:
			if (levitation != null):
				levitation.on = false;
				levitation = null;


		INVISIBLE:
			alpha( 1 );

		PARALYSED:
			paused = false;

		FROZEN:
			if (iceBlock != null):
				iceBlock.melt();
				iceBlock = null;

			paused = false;

		ILLUMINATED:
			if (halo != null):
				halo.putOut();

#@Override
func update() -> void:

	super.update();

	if (paused && listener != null):
		listener.onComplete( curAnim );


	if (flashTime > 0):
		flashTime -= Game.elapsed
		if flashTime <= 0:
			resetColor();


	if (burning != null):
		burning.visible = visible;

	if (levitation != null):
		levitation.visible = visible;

	if (iceBlock != null):
		iceBlock.visible = visible;

	if (sleeping):
		showSleep();
	else:
		hideSleep();

	if (emo != null):
		emo.visible = visible;



func showSleep() -> void:
	if (emo is EmoIcon.Sleep):
		pass
	else:
		if (emo != null):
			emo.killAndErase();

		emo = EmoIcon.Sleep.new( self );



func hideSleep() -> void:
	if (emo is EmoIcon.Sleep):
		emo.killAndErase();
		emo = null;



func showAlert() -> void:
	if (emo is EmoIcon.Alert):
		pass
	else:
		if (emo != null):
			emo.killAndErase();

		emo = EmoIcon.Alert.new( self );



func hideAlert() -> void:
	if (emo is EmoIcon.Alert):
		emo.killAndErase();
		emo = null;



#@Override
func kill() -> void:
	super.kill();

	if (emo != null):
		emo.killAndErase();
		emo = null;



#@Override
func onComplete(tweener: PTweener) -> void:
	if (tweener == jumpTweener):

		if (visible && Level.water[ch.pos] && !ch.flying):
			GameScene.ripple( ch.pos );

		if (jumpCallback != null):
			jumpCallback.call();


	elif (tweener == motion):

		isMoving = false;

		motion.killAndErase();
		motion = null;



#@Override
func onComplete_anim(anim: Animation) -> void:

	if (animCallback != null):
		animCallback.call();
		animCallback = null;
	else:

		if (anim == attack):

			idle();
			ch.onAttackComplete();

		elif (anim == operate):

			idle();
			ch.onOperateComplete();
