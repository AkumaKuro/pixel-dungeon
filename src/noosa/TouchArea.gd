class_name TouchArea
extends Visual #implements Signal.Listener<Touchscreen.Touch> {


# Its target can be toucharea itself
var target: Visual

var touch: Touchscreen.Touch = null;

func _init(target: Visual):
	super( 0, 0, 0, 0 );
	this.target = target;

	Touchscreen.event.add( this );

func _init_area(x: float,y: float,width: float,height: float ):
	super( x, y, width, height );
	this.target = this;

	visible = false;

	Touchscreen.event.add( this );


#@Override
func onSignal(touch: Touch) -> void:

	if (!isActive()):
		return;


	var hit: bool = touch != null && target.overlapsScreenPoint(touch.start.x,touch.start.y );

	if (hit):

		Touchscreen.event.cancel();

		if (touch.down):

			if (this.touch == null):
				this.touch = touch;

			onTouchDown( touch );

		else:

			onTouchUp( touch );

			if (this.touch == touch):
				this.touch = null;
				onClick( touch );

	else:
		if (touch == null && this.touch != null):
			onDrag( this.touch );

		elif (self.touch != null && touch != null && !touch.down):
			onTouchUp( touch );
			this.touch = null;





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
	Touchscreen.event.remove( self );
	super.destroy();
