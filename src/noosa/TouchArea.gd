class_name TouchArea
extends Visual #implements Signal.Listener<Touchscreen.Touch> {


# Its target can be toucharea itself
var target: Visual

var touch: Touch = null;

func _init(target: Visual):
	super( 0, 0, 0, 0 );
	self.target = target;

	Touchscreen.event.append( self );

func _init_area(x: float,y: float,width: float,height: float ):
	super._init( x, y, width, height );
	self.target = self;

	visible = false;

	Touchscreen.event.append( self );


#@Override
func onSignal(touch: Touch) -> void:

	if (!isActive()):
		return;


	var hit: bool = touch != null && target.overlapsScreenPoint(touch.start.x,touch.start.y );

	if (hit):

		Touchscreen.event.cancel();

		if (touch.down):

			if (self.touch == null):
				self.touch = touch;

			onTouchDown( touch );

		else:

			onTouchUp( touch );

			if (self.touch == touch):
				self.touch = null;
				onClick( touch );

	else:
		if (touch == null && self.touch != null):
			onDrag( self.touch );

		elif (self.touch != null && touch != null && !touch.down):
			onTouchUp( touch );
			self.touch = null;





func onTouchDown(touch: Touch) -> void:
	pass

func onTouchUp(touch: Touch) -> void:
	pass

func onClick(touch: Touch) -> void:
	pass

func onDrag(touch: Touch) -> void:
	pass

func reset() -> void:
	touch = null;


#@Override
func destroy() -> void:
	Touchscreen.event.erase( self );
	super.destroy();
