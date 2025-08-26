class_name PButton
extends Component

static var longClick: float = 1

var hotArea: TouchArea

var pressed: bool
var pressTime: float

var processed: bool

#@Override
func createChildren() -> void:
	hotArea = TouchArea.new( 0, 0, 0, 0 )
	hotArea.onTouchDown.bind(
		func(touch: Touch) -> void:
			pressed = true;
			pressTime = 0;
			processed = false;
			PButton.self.onTouchDown();
	)
	hotArea.onTouchUp.bind(
		func(touch: Touch):
			pressed = false;
			Button.this.onTouchUp();
	)
	hotArea.onClick.bind(
		func(touch: Touch):
			if (!processed):
				Button.this.onClick();

	)

	add( hotArea );


#@Override
func update() -> void:
	super.update();

	hotArea.active = visible;

	if (pressed):
		pressTime += Game.elapsed
		if (pressTime >= longClick):
			pressed = false;
			if (onLongClick()):

				hotArea.reset();
				processed = true;
				onTouchUp();

				Game.vibrate( 50 );





func onTouchDown() -> void:
	pass
func onTouchUp() -> void:
	pass
func onClick() -> void:
	pass

func onLongClick() -> bool:
	return false;


#@Override
func layout() -> void:
	hotArea.x = x;
	hotArea.y = y;
	hotArea.width = width;
	hotArea.height = height;
