class_name PickedUpItem
extends ItemSprite

const DISTANCE: float = DungeonTilemap.SIZE
const DURATION: float = 0.2

var dstX: float
var dstY: float
var left: float

func _init() -> void:
	super();

	originToCenter();

	active = false
	visible = false



func reset(item: Item, dstX: float, dstY: float) -> void:
	view( item.image(), item.glowing() );

	active = true
	visible = true


	self.dstX = dstX - ItemSprite.SIZE / 2;
	self.dstY = dstY - ItemSprite.SIZE / 2;
	left = DURATION;

	x = self.dstX - DISTANCE;
	y = self.dstY - DISTANCE;
	alpha( 1 );


#@Override
func update() -> void:
	super.update();

	left -= Game.elapsed
	if (left <= 0):

		visible = false
		active = false


	else:
		var p: float = left / DURATION;
		scale.set(sqrt( p ) );
		var offset: float = DISTANCE * p;
		x = dstX - offset;
		y = dstY - offset;
