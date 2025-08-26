class_name Camera
extends Gizmo

static var all: Array[Camera] = []

static var invW2: float
static var invH2: float

static var main: Camera

var zoom: float

var x: int
var y: int
var width: int
var height: int

var screenWidth: int
var screenHeight: int

var matrix: PackedFloat32Array

var scroll: PointF
var target: Visual

var shakeMagX: float = 10
var shakeMagY: float = 10
var shakeTime: float = 0
var shakeDuration: float= 1

var shakeX: float
var shakeY: float

static func reset() -> Camera:
	return reset_c( createFullscreen( 1 ) );


static func reset_c(newCamera: Camera) -> Camera:

	invW2 = 2 / Game.width;
	invH2 = 2 / Game.height;

	var length: int = all.size();
	for i: int in range(length):
		all.get( i ).destroy();

	all.clear();
	main = add( newCamera )
	return main


static func add(camera: Camera) -> Camera:
	all.append( camera );
	return camera;


static func remove_camera(camera: Camera) -> Camera:
	all.erase( camera );
	return camera;


static func updateAll() -> void:
	var length: int = all.size();
	for i: int in range(length):
		var c: Camera = all.get( i );
		if (c.exists && c.active):
			c.update();




static func createFullscreen(zoom: float) -> Camera:
	var w: int = ceili( Game.width / zoom );
	var h: int = ceili( Game.height / zoom );
	return Camera.new(
		(Game.width - w * zoom) / 2,
		(Game.height - h * zoom) / 2,
		w, h, zoom );


func _init(x: int,y: int,width: int,height: int, zoom: float) -> void:

	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	self.zoom = zoom;

	screenWidth = (int)(width * zoom);
	screenHeight = (int)(height * zoom);

	scroll = PointF.new();

	matrix = []
	matrix.resize(16)
	Matrix.setIdentity( matrix );


#@Override
func destroy() -> void:
	target = null;
	matrix = []


func zoom_f(value: float) -> void:
	zoom_pos( value,
		scroll.x + width / 2,
		scroll.y + height / 2 );


func zoom_pos(value: float,fx: float,fy: float ) -> void:

	zoom = value;
	width = (int)(screenWidth / zoom);
	height = (int)(screenHeight / zoom);

	focusOn( fx, fy );


func resize(width: int, height: int) -> void:
	self.width = width;
	self.height = height;
	screenWidth = (width * zoom);
	screenHeight = (height * zoom);


#@Override
func update() -> void:
	super.update();

	if (target != null):
		focusOn_v( target );


	shakeTime -= Game.elapsed
	if (shakeTime > 0):
		var damping: float = shakeTime / shakeDuration;
		shakeX = randf_range( -shakeMagX, +shakeMagX ) * damping;
		shakeY = randf_range( -shakeMagY, +shakeMagY ) * damping;
	else:
		shakeX = 0;
		shakeY = 0;


	updateMatrix();


func center() -> PointF:
	return PointF.new( width / 2, height / 2 );


func hitTest( x: float, y: float ) -> bool:
	return x >= self.x && y >= self.y && x < self.x + screenWidth && y < self.y + screenHeight;


func focusOn(x: float,y: float ) -> void:
	scroll.set_float( x - width / 2, y - height / 2 );


func focusOn_point(point: PointF) -> void:
	focusOn( point.x, point.y );


func focusOn_v(visual: Visual) -> void:
	focusOn_point( visual.center() );


func screenToCamera(x: float,y: float ) -> PointF:
	return PointF.new(
		(x - self.x) / zoom + scroll.x,
		(y - self.y) / zoom + scroll.y );


func cameraToScreen(x: float,y: float ) -> Point:
	return Point.new(
		((x - scroll.x) * zoom + self.x),
		((y - scroll.y) * zoom + self.y));


func get_screenWidth() -> float:
	return width * zoom;


func get_screenHeight() -> float:
	return height * zoom;


func updateMatrix() -> void:
	matrix[0] = +zoom * invW2;
	matrix[5] = -zoom * invH2;

	matrix[12] = -1 + x * invW2 - (scroll.x + shakeX) * matrix[0];
	matrix[13] = +1 - y * invH2 - (scroll.y + shakeY) * matrix[5];



func shake(magnitude: float,duration: float ) -> void:
	shakeMagX = magnitude
	shakeMagY = magnitude;
	shakeTime = duration
	shakeDuration = duration;
