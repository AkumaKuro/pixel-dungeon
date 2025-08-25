class_name Tool
extends Button

const BGCOLOR: int = 0x7B8073;

var base: Image

func _init(x: int,y: int,width: int,height: int ) -> void:
	super();

	base.frame( x, y, width, height );

	self.width = width;
	self.height = height;


#@Override
func createChildren() -> void:
	super.createChildren();

	base = Image.new( Assets.TOOLBAR );
	add( base );


#@Override
func layout() -> void:
	super.layout();

	base.x = x;
	base.y = y;


#@Override
func onTouchDown() -> void:
	base.brightness( 1.4);


#@Override
func onTouchUp() -> void:
	if (active):
		base.resetColor();
	else:
		base.tint( BGCOLOR, 0.7);



func enable(value: bool) -> void:
	if (value != active):
		if (value):
			base.resetColor();
		else:
			base.tint( BGCOLOR, 0.7);

		active = value;
