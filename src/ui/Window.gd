class_name PWindow
extends Group # implements Signal.Listener<Key> {

var width: int
var height: int

var blocker: TouchArea
var shadow: ShadowBox
var chrome: NinePatch

const TITLE_COLOR: int = 0xFFFF44;

func _init() -> void:
	this( 0, 0, Chrome.get( Chrome.Type.WINDOW ) );


func _init_size( width: int, height: int ) -> void:
	this( width, height, Chrome.get( Chrome.Type.WINDOW ) );


func _init_all(width: int, height: int, chrome: NinePatch) -> void:
	super();

	blocker = TouchArea.new(0, 0, PixelScene.uiCamera.width, PixelScene.uiCamera.height )
	blocker.onClick.bind(
		func(touch: Touch):
			if (!Window.this.chrome.overlapsScreenPoint(
				touch.current.x,
				touch.current.y )):

				onBackPressed();

	)
	blocker.camera = PixelScene.uiCamera;
	add( blocker );

	this.chrome = chrome;

	this.width = width;
	this.height = height;

	shadow = ShadowBox.new();
	shadow.am = 0.5
	shadow.camera =  PixelScene.uiCamera if PixelScene.uiCamera.visible else Camera.main;
	add( shadow );

	chrome.x = -chrome.marginLeft();
	chrome.y = -chrome.marginTop();
	chrome.size(
		width - chrome.x + chrome.marginRight(),
		height - chrome.y + chrome.marginBottom() );
	add( chrome );

	camera = Camera.new( 0, 0,
		chrome.width,
		chrome.height,
		PixelScene.defaultZoom );
	camera.x = (Game.width - camera.width * camera.zoom) / 2;
	camera.y = (Game.height - camera.height * camera.zoom) / 2;
	camera.scroll.set( chrome.x, chrome.y );
	Camera.add( camera );

	shadow.boxRect(
		camera.x / camera.zoom,
		camera.y / camera.zoom,
		chrome.width(), chrome.height );

	Keys.event.add( this );


func resize(w: int,h: int) -> void:
	this.width = w;
	this.height = h;

	chrome.size(
		width + chrome.marginHor(),
		height + chrome.marginVer() );

	camera.resize( chrome.width, chrome.height );
	camera.x = (Game.width - camera.screenWidth()) / 2;
	camera.y = (Game.height - camera.screenHeight()) / 2;

	shadow.boxRect( camera.x / camera.zoom, camera.y / camera.zoom, chrome.width(), chrome.height );


func hide() -> void:
	parent.erase( this );
	destroy();


#@Override
func destroy() -> void:
	super.destroy();

	Camera.remove( camera );
	Keys.event.remove( this );


#@Override
func onSignal(key: Key) -> void:
	if (key.pressed):
		match key.code:
			Keys.BACK:
				onBackPressed();

			Keys.MENU:
				onMenuPressed();




	Keys.event.cancel();


func onBackPressed() -> void:
	hide();


func onMenuPressed() -> void:
	pass
