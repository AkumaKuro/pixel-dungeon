class_name PixelScene
extends Scene

# Minimum virtual display size for portrait orientation
const MIN_WIDTH_P: float		= 128;
const MIN_HEIGHT_P: float		= 224;

# Minimum virtual display size for landscape orientation
const MIN_WIDTH_L: float		= 224;
const MIN_HEIGHT_L: float		= 160;

static var defaultZoom: float = 0;
static var minZoom: float;
static var maxZoom: float;

static var uiCamera: Camera

static var font1x: BitmapText.Font
static var font15x: BitmapText.Font
static var font2x: BitmapText.Font
static var font25x: BitmapText.Font
static var font3x: BitmapText.Font

#@Override
func create() -> void:

	super.create();

	GameScene.scene = null;

	var minWidth: float
	var minHeight: float
	if (PixelDungeon.landscape()):
		minWidth = MIN_WIDTH_L;
		minHeight = MIN_HEIGHT_L;
	else:
		minWidth = MIN_WIDTH_P;
		minHeight = MIN_HEIGHT_P;


	defaultZoom = ceil( Game.density * 2.5 )
	while ((
		Game.width / defaultZoom < minWidth ||
		Game.height / defaultZoom < minHeight
		) && defaultZoom > 1):

		defaultZoom -= 1


	if (PixelDungeon.scaleUp()):
		while (
			Game.width / (defaultZoom + 1) >= minWidth &&
			Game.height / (defaultZoom + 1) >= minHeight):

			defaultZoom += 1


	minZoom = 1;
	maxZoom = defaultZoom * 2;

	Camera.reset(PixelCamera.new( defaultZoom ) );

	var uiZoom: float = defaultZoom;
	uiCamera = Camera.createFullscreen( uiZoom );
	Camera.add( uiCamera );

	if (font1x == null):

		# 3x5 (6)
		font1x = Font.colorMarked(
			BitmapCache.get( Assets.FONTS1X ), 0x00000000, BitmapText.Font.LATIN_FULL );
		font1x.baseLine = 6;
		font1x.tracking = -1;

		# 5x8 (10)
		font15x = Font.colorMarked(
				BitmapCache.get( Assets.FONTS15X ), 12, 0x00000000, BitmapText.Font.LATIN_FULL );
		font15x.baseLine = 9;
		font15x.tracking = -1;

		# 6x10 (12)
		font2x = Font.colorMarked(
			BitmapCache.get( Assets.FONTS2X ), 14, 0x00000000, BitmapText.Font.LATIN_FULL );
		font2x.baseLine = 11;
		font2x.tracking = -1;

		# 7x12 (15)
		font25x = Font.colorMarked(
			BitmapCache.get( Assets.FONTS25X ), 17, 0x00000000, BitmapText.Font.LATIN_FULL );
		font25x.baseLine = 13;
		font25x.tracking = -1;

		# 9x15 (18)
		font3x = Font.colorMarked(
			BitmapCache.get( Assets.FONTS3X ), 22, 0x00000000, BitmapText.Font.LATIN_FULL );
		font3x.baseLine = 17;
		font3x.tracking = -2;



#@Override
func destroy() -> void:
	super.destroy();
	Touchscreen.event.removeAll();


static var font: BitmapText.Font
static var scale: float

static func chooseFont(size: float) -> void:
	chooseFont( size, defaultZoom );


static func chooseFont_zoom( size: float, zoom: float ) -> void:

	var pt: float = size * zoom;

	if (pt >= 19):

		scale = pt / 19;
		if (1.5 <= scale && scale < 2):
			font = font25x;
			scale = (pt / 14);
		else:
			font = font3x;
			scale = scale;


	elif (pt >= 14):

		scale = pt / 14;
		if (1.8 <= scale && scale < 2):
			font = font2x;
			scale = (pt / 12);
		else:
			font = font25x;
			scale = scale;


	elif (pt >= 12):

		scale = pt / 12;
		if (1.7 <= scale && scale < 2):
			font = font15x;
			scale = (int)(pt / 10);
		else:
			font = font2x;
			scale = scale;


	elif (pt >= 10):

		scale = pt / 10;
		if (1.4 <= scale && scale < 2):
			font = font1x;
			scale = (pt / 7);
		else:
			font = font15x;
			scale = scale;


	else:

		font = font1x;
		scale = Math.max( 1, (int)(pt / 7) );



	scale /= zoom;


static func createText(size: float) -> BitmapText:
	return createText( null, size );

static func createText_t(text: String, size: float) -> BitmapText:

	chooseFont( size );

	var result: BitmapText = BitmapText.new( text, font );
	result.scale.set( scale );

	return result;


static func createMultiline(size: float) -> BitmapTextMultiline:
	return createMultiline( null, size );


static func createMultiline_t(text: String, size: float) -> BitmapTextMultiline:

	chooseFont( size );

	var result: BitmapTextMultiline = BitmapTextMultiline.new( text, font );
	result.scale.set( scale );

	return result;


static func align_camera(camera: Camera, pos: float) -> float:
	return ((int)(pos * camera.zoom)) / camera.zoom;


# This one should be used for UI elements
static func align(pos: float) -> float:
	return ((int)(pos * defaultZoom)) / defaultZoom;


static func align_visual(v: Visual) -> void:
	var c: Camera = v.camera();
	v.x = align_camera( c, v.x );
	v.y = align_camera( c, v.y );


static var noFade: bool = false;
func fadeIn() -> void:
	if (noFade):
		noFade = false;
	else:
		fadeIn( 0xFF000000, false );



func fadeIn_color_light(color: int, light: bool) -> void:
	add(Fader.new( color, light ) );

static func showBadge(badge: Badges.Badge) -> void:
	var banner: BadgeBanner = BadgeBanner.show( badge.image );
	banner.camera = uiCamera;
	banner.x = align( banner.camera, (banner.camera.width - banner.width) / 2 );
	banner.y = align( banner.camera, (banner.camera.height - banner.height) / 3 );
	Game.scene().add( banner );


class Fader extends ColorBlock:

	static var FADE_TIME: float = 1

	var light: bool

	var time: float

	func _init(color: int, light: bool) -> void:
		super( uiCamera.width, uiCamera.height, color );

		this.light = light;

		camera = uiCamera;

		alpha( 1);
		time = FADE_TIME;


	#@Override
	func update() -> void:

		super.update();

		time -= Game.elapsed
		if ((time) <= 0):
			alpha( 0);
			parent.remove( this );
		else:
			alpha( time / FADE_TIME );



	#@Override
	func draw() -> void:
		if (light):
			GLES20.glBlendFunc( GL10.GL_SRC_ALPHA, GL10.GL_ONE );
			super.draw();
			GLES20.glBlendFunc( GL10.GL_SRC_ALPHA, GL10.GL_ONE_MINUS_SRC_ALPHA );
		else:
			super.draw();




class PixelCamera extends Camera:

	func _init(zoom: float) -> void:
		super(
			(Game.width - Math.ceil( Game.width / zoom ) * zoom) / 2,
			(Game.height - Math.ceil( Game.height / zoom ) * zoom) / 2,
			Math.ceil( Game.width / zoom ),
			Math.ceil( Game.height / zoom ), zoom );


	#@Override
	func updateMatrix() -> void:
		var sx: float = align( this, scroll.x + shakeX );
		var sy: float = align( this, scroll.y + shakeY );

		matrix[0] = +zoom * invW2;
		matrix[5] = -zoom * invH2;

		matrix[12] = -1 + x * invW2 - sx * matrix[0];
		matrix[13] = +1 - y * invH2 - sy * matrix[5];
