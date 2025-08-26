class_name Component
extends Group

var x: float
var y: float
var width: float
var height: float

func _init() -> void:
	super();
	createChildren();


func setPos(x: float,y: float ) -> Component:
	self.x = x;
	self.y = y;
	layout();

	return self;


func setSize(width: float,height: float ) -> Component:
	self.width = width;
	self.height = height;
	layout();

	return self;


func setRect(x: float,y: float,width: float,height: float ) -> Component:
	self.x = x;
	self.y = y;
	self.width = width;
	self.height = height;
	layout();

	return self;


func inside(x: float,y: float ) -> bool:
	return x >= self.x && y >= self.y && x < self.x + width && y < self.y + height;


func fill(c: Component) -> void:
	setRect( c.x, c.y, c.width, c.height );


func left() -> float:
	return x;


func right() -> float:
	return x + width;


func centerX() -> float:
	return x + width / 2;


func top() -> float:
	return y;


func bottom() -> float:
	return y + height;


func centerY() -> float:
	return y + height / 2;


func set_width() -> float:
	return width;


func set_height() -> float:
	return height;


func createChildren() -> void:
	pass


func layout() -> void:
	pass
