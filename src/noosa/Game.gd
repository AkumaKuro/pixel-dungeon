#/*
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


class_name Game #implements GLSurfaceView.Renderer, View.OnTouchListener {


static var instance: Game

# Actual size of the screen
static var width: int
static var height: int

# Density: mdpi=1, hdpi=1.5, xhdpi=2...
static var density: float = 1;

static var version: String

# Current scene
var scene: Scene
# New scene we are going to switch to
var requestedScene: Scene
# true if scene switch is requested
var requestedReset: bool = true;
# New scene class
var sceneClass: Scene

# Current time in milliseconds
var now: float
# Milliseconds passed since previous update
var step: float

static var timeScale: float = 1
static var elapsed: float = 0

var view: GLSurfaceView
var holder: SurfaceHolder

# Accumulated touch events
var motionEvents: Array[MotionEvent] = []

# Accumulated key events
var keysEvents: Array[KeyEvent] = []

func _init(c: Scene) -> void:
	super();
	sceneClass = c;


#@Override
func onCreate(savedInstanceState: Bundle) -> void:
	super.onCreate( savedInstanceState );

	BitmapCache.context = self
	TextureCache.context = self
	instance = self

	var m: DisplayMetrics = DisplayMetrics.new();
	getWindowManager().getDefaultDisplay().getMetrics( m );
	density = m.density;

	version = getPackageManager().getPackageInfo( getPackageName(), 0 ).versionName;
	if !version:
		version = "???";


	setVolumeControlStream( AudioManager.STREAM_MUSIC );

	#view = GLSurfaceView.new( self );
	#view.setEGLContextClientVersion( 2 );
	#view.setEGLConfigChooser( false );
	#view.setRenderer( this );
	#view.setOnTouchListener( this );
	#setContentView( view );


#@Override
func onResume() -> void:
	super.onResume();

	now = 0;
	#view.onResume();

	Music.INSTANCE.resume();
	Sample.INSTANCE.resume();


#@Override
func onPause() -> void:
	super.onPause();

	if (scene != null):
		scene.pause();


	#view.onPause();
	Script.reset();

	Music.INSTANCE.pause();
	Sample.INSTANCE.pause();


#@Override
func onDestroy() -> void:
	super.onDestroy();
	destroyGame();

	Music.INSTANCE.mute();
	Sample.INSTANCE.reset();


#@SuppressLint({ "Recycle", "ClickableViewAccessibility" })
#@Override
func onTouch(event: MotionEvent) -> bool: #view: View,
	await func(motionEvents):
		motionEvents.add( MotionEvent.obtain( event ) );

	return true;


#@Override
func onKeyDown(keyCode: int, event: KeyEvent) -> bool:

	if (keyCode == Keys.VOLUME_DOWN ||
		keyCode == Keys.VOLUME_UP):

		return false;


	await func(motionEvents):
		keysEvents.add( event );

	return true;


#@Override
func onKeyUp(keyCode: int, event: KeyEvent) -> bool:

	if (keyCode == Keys.VOLUME_DOWN ||
		keyCode == Keys.VOLUME_UP):

		return false;


	await func (motionEvents):
		keysEvents.add( event );

	return true;


#@Override
func onDrawFrame(gl: GL10) -> void:

	if (width == 0 || height == 0):
		return;


	SystemTime.tick();
	var rightNow: float = SystemTime.now;
	step = (0 if now == 0 else rightNow - now);
	now = rightNow;

	step();

	NoosaScript.get().resetCamera();
	GLES20.glScissor( 0, 0, width, height );
	GLES20.glClear( GLES20.GL_COLOR_BUFFER_BIT );
	draw();


#@Override
func onSurfaceChanged(gl: GL10, width: int, height: int) -> void:

	GLES20.glViewport( 0, 0, width, height );

	Game.width = width;
	Game.height = height;



#@Override
func onSurfaceCreated(gl: GL10, config: EGLConfig) -> void:
	GLES20.glEnable( GL10.GL_BLEND );
	# For premultiplied alpha:
	# GLES20.glBlendFunc( GL10.GL_ONE, GL10.GL_ONE_MINUS_SRC_ALPHA );
	GLES20.glBlendFunc( GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA );

	GLES20.glEnable( GL10.GL_SCISSOR_TEST );

	TextureCache.reload();


func destroyGame() -> void:
	if (scene != null):
		scene.destroy();
		scene = null;


	instance = null;


static func resetScene() -> void:
	switchScene( instance.sceneClass );


static func switchScene(c: Scene) -> void:
	instance.sceneClass = c;
	instance.requestedReset = true;


static func scene_f() -> Scene:
	return instance.scene;


func step_f() -> void:

	if (requestedReset):
		requestedReset = false;

		requestedScene = sceneClass.newInstance();
		switchScene()

	update();


func draw() -> void:
	scene.draw();


func switchScene_f() -> void:

	Camera.reset();

	if (scene != null):
		scene.destroy();

	scene = requestedScene;
	scene.create();

	Game.elapsed = 0
	Game.timeScale = 1


func update() -> void:
	Game.elapsed = Game.timeScale * step * 0.001

	await func (motionEvents):
		Touchscreen.processTouchEvents( motionEvents );
		motionEvents.clear();

	await func (keysEvents):
		Keys.processTouchEvents( keysEvents );
		keysEvents.clear();


	scene.update();
	Camera.updateAll();


static func vibrate(milliseconds: int) -> void:
	(instance.getSystemService( VIBRATOR_SERVICE ) as Vibrator).vibrate( milliseconds );
