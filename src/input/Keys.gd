class_name Keys


const BACK: int = KeyEvent.KEYCODE_BACK;
const MENU: int = KeyEvent.KEYCODE_MENU;
const VOLUME_UP: int = KeyEvent.KEYCODE_VOLUME_UP;
const VOLUME_DOWN: int = KeyEvent.KEYCODE_VOLUME_DOWN;

static var event: Signal[Key] = Signal[Key].new( true );

static func processTouchEvents(events: ArrayList[KeyEvent]) -> void:

	var size: int = events.size();
	for i: int in range(size):

		var e: KeyEvent = events.get( i );

		match (e.getAction()):
			KeyEvent.ACTION_DOWN:
				event.dispatch(Key.new( e.getKeyCode(), true ) );

			KeyEvent.ACTION_UP:
				event.dispatch(Key.new( e.getKeyCode(), false ) );

class Key:

	var code: int
	var pressed: bool

	func _init(code: int, pressed: bool) -> void:
		self.code = code;
		self.pressed = pressed;
