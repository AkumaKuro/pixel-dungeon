class_name Touchscreen


static var event: PSignal = Signal.new( true )

static var pointers: Dictionary[Integer,Touch] = {}

static var x: float
static var y: float
static var touched: bool

static func processTouchEvents(events: Array[MotionEvent]) -> void:

	var size: int = events.size();
	for i: int in range(size):

		var e: MotionEvent = events.get( i );
		var touch: Touch

		match (e.getAction() & MotionEvent.ACTION_MASK):

			MotionEvent.ACTION_DOWN:
				touched = true;
				touch = Touch.new( e, 0 );
				pointers.put( e.getPointerId( 0 ), touch );
				event.dispatch( touch );


			MotionEvent.ACTION_POINTER_DOWN:
				var index: int = e.getActionIndex();
				touch = Touch.new( e, index );
				pointers.put( e.getPointerId( index ), touch );
				event.dispatch( touch );


			MotionEvent.ACTION_MOVE:
				var count: int = e.getPointerCount();
				for j: int in range (count):
					pointers.get( e.getPointerId( j ) ).update( e, j );

				event.dispatch( null );


			MotionEvent.ACTION_POINTER_UP:
				event.dispatch( pointers.remove( e.getPointerId( e.getActionIndex() ) ).up() );


			MotionEvent.ACTION_UP:
				touched = false;
				event.dispatch( pointers.remove( e.getPointerId( 0 ) ).up() );




		e.recycle();
