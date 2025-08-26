class_name Point

var x: int
var y: int



func _init(x: int,y: int ) -> void:
	self.x = x;
	self.y = y;


func set_i( x: int, y: int ) -> Point:
	self.x = x;
	self.y = y;
	return self;


func set_p(p: Point) -> Point:
	x = p.x;
	y = p.y;
	return self;


func clone() -> Point:
	return Point.new(x, y)


func scale(f: float) -> Point:
	self.x *= f;
	self.y *= f;
	return self;


func offset(dx: int,dy: int) -> Point:
	x += dx;
	y += dy;
	return self;


func offset_p(d: Point) -> Point:
	x += d.x;
	y += d.y;
	return self;


#@Override
func equals(obj: Object) -> bool:
	if (obj is Point):
		var p: Point = obj as Point
		return p.x == x && p.y == y;
	else:
		return false;
