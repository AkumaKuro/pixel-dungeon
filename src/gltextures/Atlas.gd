class_name Atlas

var tx: SmartTexture

var namedFrames: Dictionary[Object,Rect2]

var uvLeft: float
var uvTop: float
var uvWidth: float
var uvHeight: float
var cols: int

func _init(tx: SmartTexture) -> void:

	self.tx = tx;
	tx.atlas = self;

	namedFrames = {}


func add( key: Object, left: int, top: int, right: int, bottom: int ) -> void:
	add_rect( key, uvRect( tx, left, top, right, bottom ) );


func add_rect( key: Object, rect: Rect2 ) -> void:
	namedFrames[key] = rect


func grid( width: int ) -> void:
	grid_v( width, tx.height );


func grid_v( width: int, height: int ) -> void:
	grid_all( 0, 0, width, height, tx.width / width );


func grid_all( left: int, top: int, width: int, height: int, cols: int ) -> void:
	uvLeft	= left	/ tx.width;
	uvTop	= top	/ tx.height;
	uvWidth	= width	/ tx.width;
	uvHeight= height	/ tx.height;
	self.cols = cols;


func get_index(index: int) -> Rect2:
	var x: float = index % cols;
	var y: float = index / cols;
	var left: float = uvLeft + x * uvWidth;
	var top: float = uvTop	+ y * uvHeight;

	var start: Vector2 = Vector2(left, top)
	var size: Vector2 = Vector2(uvWidth, uvHeight)
	return Rect2(start, size);


func get_key(key: Object) -> Rect2:
	return namedFrames[key]


func width(rect: Rect2) -> float:
	return rect.size.x * tx.width;


func height(rect: Rect2) -> float:
	return rect.size.y * tx.height;


static func uvRect(tx: SmartTexture, left: int, top: int, right: int, bottom: int) -> Rect2:
	var start: Vector2 = Vector2(left / tx.width, top / tx.height)
	var size: Vector2 = Vector2(right / tx.width, bottom / tx.height) - start
	return Rect2(start, size);
