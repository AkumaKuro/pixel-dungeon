class_name Gizmo


var exists: bool
var alive: bool
var active: bool
var visible: bool

var parent: Group

var camera: Camera

func _init() -> void:
	exists	= true;
	alive	= true;
	active	= true;
	visible	= true;


func destroy() -> void:
	parent = null;


func update() -> void:
	pass

func draw() -> void:
	pass

func kill() -> void:
	alive = false;
	exists = false;


# Not exactly opposite to "kill" method
func revive() -> void:
	alive = true;
	exists = true;


func get_camera() -> Camera:
	if (camera != null):
		return camera;
	elif (parent != null):
		return parent.camera();
	else:
		return null;



func isVisible() -> bool:
	if (parent == null):
		return visible;
	else:
		return visible && parent.isVisible();



func isActive() -> bool:
	if (parent == null):
		return active;
	else:
		return active && parent.isActive();



func killAndErase() -> void:
	kill();
	if (parent != null):
		parent.erase( self );



func remove(g: Gizmo) -> Gizmo:
	if (parent != null):
		parent.remove( self );
	return null
