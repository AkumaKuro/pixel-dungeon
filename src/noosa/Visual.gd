class_name Visual
extends Gizmo

var x: float
var y: float
var width: float
var height: float

var scale: PointF
var origin: PointF

var matrix: PackedFloat32Array

var rm: float
var gm: float
var bm: float
var am: float
var ra: float
var ga: float
var ba: float
var aa: float

var speed: PointF
var acc: PointF

var angle: float
var angularSpeed: float

func _init( x: float, y: float, width: float, height: float ) -> void:
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;

	scale = PointF.new( 1, 1 );
	origin = PointF.new();

	matrix = []
	matrix.resize(16)

	resetColor();

	speed = PointF.new();
	acc = PointF.new();


#@Override
func update() -> void:
	updateMotion();


#@Override
func draw() -> void:
	updateMatrix();


func updateMatrix() -> void:
	Matrix.setIdentity( matrix );
	Matrix.translate( matrix, x, y );
	Matrix.translate( matrix, origin.x, origin.y );
	if (angle != 0):
		Matrix.rotate( matrix, angle );

	if (scale.x != 1 || scale.y != 1):
		Matrix.scale( matrix, scale.x, scale.y );

	Matrix.translate( matrix, -origin.x, -origin.y );


func point() -> PointF:
	return PointF.new( x, y );


func point_f(p: PointF) -> PointF:
	x = p.x;
	y = p.y;
	return p;


func point_i(p: Point) -> Point:
	x = p.x;
	y = p.y;
	return p;


func center() -> PointF:
	return PointF.new( x + width, y + height ) / 2


func center_f(p: PointF) -> PointF:
	x = p.x - width / 2;
	y = p.y - height / 2;
	return p;


func get_width() -> float:
	return width * scale.x;


func get_height() -> float:
	return height * scale.y;


func updateMotion() -> void:

	var elapsed: float = Game.elapsed;

	var d: float = (GameMath.speed( speed.x, acc.x ) - speed.x) / 2;
	speed.x += d;
	x += speed.x * elapsed;
	speed.x += d;

	d = (GameMath.speed( speed.y, acc.y ) - speed.y) / 2;
	speed.y += d;
	y += speed.y * elapsed;
	speed.y += d;

	angle += angularSpeed * elapsed;


func alpha(value: float) -> void:
	am = value;
	aa = 0;


func get_alpha() -> float:
	return am + aa;


func invert() -> void:
	rm = -1
	gm = -1
	bm = -1
	ra = +1
	ga = +1
	ba = +1


func lightness(value: float) -> void:
	if (value < 0.5):
		rm = value * 2
		gm = value * 2
		bm = value * 2
		ra = 0
		ga = 0
		ba = 0;
	else:
		rm = 2 - value * 2
		gm = 2 - value * 2
		bm = 2 - value * 2
		ra = value * 2 - 1
		ga = value * 2 - 1
		ba = value * 2 - 1



func brightness(value: float) -> void:
	rm = value
	gm = value
	bm = value;


func tint(r: float,g: float,b: float,strength: float ) -> void:
	rm = 1 - strength
	gm = 1 - strength
	bm = 1 - strength;
	ra = r * strength;
	ga = g * strength;
	ba = b * strength;


func tint_hex(color: int, strength: float ) -> void:
	rm = 1 - strength
	gm = 1 - strength
	bm = 1 - strength;
	ra = ((color >> 16) & 0xFF) / 255 * strength;
	ga = ((color >> 8) & 0xFF) / 255 * strength;
	ba = (color & 0xFF) / 255 * strength;


func color(r: float,g: float,b: float ) -> void:
	rm = 0
	gm = 0
	bm = 0;
	ra = r;
	ga = g;
	ba = b;


func color_hex(color: int) -> void:
	color( ((color >> 16) & 0xFF) / 255, ((color >> 8) & 0xFF) / 255, (color & 0xFF) / 255);


func hardlight(r: float,g: float,b: float ) -> void:
	ra = 0;
	ga = 0;
	ba = 0;
	rm = r;
	gm = g;
	bm = b;


func hardlight_hex(color: int) -> void:
	hardlight( (color >> 16) / 255, ((color >> 8) & 0xFF) / 255, (color & 0xFF) / 255 );


func resetColor() -> void:
	rm = 1;
	gm = 1;
	bm = 1;
	am = 1;
	ra = 0;
	ga = 0;
	ba = 0;
	aa = 0;


func overlapsPoint(x: float,y: float ) -> bool:
	return x >= self.x && x < self.x + width * scale.x && y >= self.y && y < self.y + height * scale.y;


func overlapsScreenPoint( x: int, y: int ) -> bool:
	var c: Camera = camera();
	if (c != null):
		var p: PointF = c.screenToCamera( x, y );
		return overlapsPoint( p.x, p.y );
	else:
		return false;



# true if its bounding box intersects its camera's bounds
func isVisible() -> bool:
	var c: Camera = camera();
	var cx: float = c.scroll.x;
	var cy: float = c.scroll.y;
	var w: float = width();
	var h: float = height();
	return x + w >= cx && y + h >= cy && x < cx + c.width && y < cy + c.height;
