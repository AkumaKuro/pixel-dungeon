class_name Touch

var start: PointF
var current: PointF
var down: bool

func _init(e: MotionEvent, index: int) -> void:

	var x: float = e.getX( index );
	var y: float = e.getY( index );

	start = PointF.new( x, y );
	current = PointF.new( x, y );

	down = true;


func update(e: MotionEvent, index: int) -> void:
	current.set( e.getX( index ), e.getY( index ) );


func up() -> Touch:
	down = false;
	return self;
