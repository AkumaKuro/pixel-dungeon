class_name JumpTweener
extends PTweener

var visual: Visual

var start: PointF
var end: PointF

var height: float

func _init(visual: Visual, pos: PointF, height: float, time: float) -> void:
	super( visual, time );

	self.visual = visual;
	start = visual.point();
	end = pos;

	self.height = height;

#@Override
func updateValues(progress: float) -> void:
	visual.point( PointF.inter( start, end, progress ).offset( 0, -height * 4 * progress * (1 - progress) ) );
