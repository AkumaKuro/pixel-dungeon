class_name Group
extends Gizmo


var members: Array[Gizmo] = []

# Accessing it is a little faster,
# than calling members.getSize()
var length: int = 0

#@Override
func destroy() -> void:
	for i: int in range(length):
		var g: Gizmo = members.get( i );
		if (g != null):
			g.destroy();

	members.clear();
	members = []
	length = 0;


#@Override
func update() -> void:
	for i: int in range(length):
		var g: Gizmo = members.get( i );
		if (g != null && g.exists && g.active):
			g.update();




#@Override
func draw() -> void:
	for i: int in range(length):
		var g: Gizmo = members.get( i );
		if (g != null && g.exists && g.visible):
			g.draw();




#@Override
func kill() -> void:
	# A killed group keeps all its members,
	# but they get killed too
	for i: int in range(length):
		var g: Gizmo = members.get( i );
		if (g != null && g.exists):
			g.kill();

	super.kill();


func indexOf(g: Gizmo) -> int:
	return members.find( g );


func add(g: Gizmo) -> Gizmo:

	if (g.parent == self):
		return g;

	if (g.parent != null):
		g.parent.remove( g );


	# Trying to find an empty space for a new member
	for i: int in range(length):
		if (members.get( i ) == null):
			members.set( i, g );
			g.parent = self;
			return g;



	members.append( g );
	g.parent = self;
	length += 1
	return g;


func addToBack(g: Gizmo) -> Gizmo:

	if (g.parent == self):
		sendToBack( g );
		return g;


	if (g.parent != null):
		g.parent.remove( g );


	if (members.get( 0 ) == null):
		members.set( 0, g );
		g.parent = self;
		return g;


	members.push_front(g);
	g.parent = self;
	length += 1
	return g;


func recycle( c: Gizmo ) -> Gizmo:

	var g: Gizmo = getFirstAvailable( c );
	if (g != null):

		return g;

	elif (c == null):

		return null;

	else:

		return add( c.newInstance() );


# Fast removal - replacing with null
func erase(g: Gizmo) -> Gizmo:
	var index: int = members.find( g );
	if (index != -1):
		members.set( index, null );
		g.parent = null;
		return g;
	else:
		return null;



# Real removal
func remove(g: Gizmo) -> Gizmo:
	var index: int = members.find( g )
	if (index != -1):
		members.remove_at(index)
		length -= 1
		g.parent = null;
		return g;
	else:
		return null;



func replace(oldOne: Gizmo,newOne: Gizmo ) -> Gizmo:
	var index: int = members.find( oldOne );
	if (index != -1):
		members.set( index, newOne );
		newOne.parent = self;
		oldOne.parent = null;
		return newOne;
	else:
		return null;



func getFirstAvailable(c: Gizmo) -> Gizmo:

	for i: int in range(length):
		var g: Gizmo = members.get( i );
		if (g != null && !g.exists && ((c == null) || g.getClass() == c)):
			return g;

	return null;


func countLiving() -> int:

	var count: int = 0;

	for i: int in range(length):
		var g: Gizmo = members.get( i );
		if (g != null && g.exists && g.alive):
			count += 1

	return count;


func countDead() -> int:

	var count: int = 0;

	for i: int in range(length):
		var g: Gizmo = members.get( i );
		if (g != null && !g.alive):
			count += 1

	return count;


func random() -> Gizmo:
	if (length > 0):
		return members.pick_random()
	else:
		return null;



func clear() -> void:
	for i: int in range(length):
		var g: Gizmo = members.get( i );
		if (g != null):
			g.parent = null;

	members.clear();
	length = 0;


func bringToFront(g: Gizmo) -> Gizmo:
	if (g in members):
		members.erase( g );
		members.append( g );
		return g;
	else:
		return null;



func sendToBack(g: Gizmo) -> Gizmo:
	if g in members:
		members.erase( g );
		members.push_front(g);
		return g;
	else:
		return null;
