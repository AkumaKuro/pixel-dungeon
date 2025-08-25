class_name QuickslotTool
extends Tool

var slot: QuickSlot

func _init( x: int, y: int, width: int, height: int, primary: bool) -> void:
	super( x, y, width, height );
	if (primary):
		slot.primary();
	else:
		slot.secondary();



#@Override
func createChildren() -> void:
	super.createChildren();

	slot = QuickSlot.new();
	add( slot );


#@Override
func layout() -> void:
	super.layout();
	slot.setRect( x + 1, y + 2, width - 2, height - 2 );


#@Override
func enable(value: bool) -> void:
	slot.enable( value );
	super.enable( value );
