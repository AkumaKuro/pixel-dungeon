class_name Camera
extends Gizmo

static var all: Array[Camera] = []

static var invW2: float
static var invH2: float

static var main: Camera

var zoom: float

var x: int
var y: int
var width: int
var height: int

var screenWidth: int
var screenHeight: int

var matrix: PackedFloat32Array

var scroll: PointF
var target: Visual

var shakeMagX: float = 10
var shakeMagY: float = 10
var shakeTime: float = 0
var shakeDuration: float= 1

var shakeX: float
var shakeY: float

static func reset() -> Camera:
	return reset( createFullscreen( 1 ) );


static func reset_c(newCamera: Camera) -> Camera:

	invW2 = 2 / Game.width;
	invH2 = 2 / Game.height;

	var length: int = all.size();
	for i: int in range(length):
		all.get( i ).destroy();

	all.clear();
	main = add( newCamera )
	return main


public static Camera add( Camera camera ) {
	all.add( camera );
	return camera;
}

public static Camera remove( Camera camera ) {
	all.remove( camera );
	return camera;
}

public static void updateAll() {
	int length = all.size();
	for (int i=0; i < length; i++) {
		Camera c = all.get( i );
		if (c.exists && c.active) {
			c.update();
		}
	}
}

public static Camera createFullscreen( float zoom ) {
	int w = (int)Math.ceil( Game.width / zoom );
	int h = (int)Math.ceil( Game.height / zoom );
	return new Camera(
		(int)(Game.width - w * zoom) / 2,
		(int)(Game.height - h * zoom) / 2,
		w, h, zoom );
}

public Camera( int x, int y, int width, int height, float zoom ) {

	this.x = x;
	this.y = y;
	this.width = width;
	this.height = height;
	this.zoom = zoom;

	screenWidth = (int)(width * zoom);
	screenHeight = (int)(height * zoom);

	scroll = new PointF();

	matrix = new float[16];
	Matrix.setIdentity( matrix );
}

@Override
public void destroy() {
	target = null;
	matrix = null;
}

public void zoom( float value ) {
	zoom( value,
		scroll.x + width / 2,
		scroll.y + height / 2 );
}

public void zoom( float value, float fx, float fy ) {

	zoom = value;
	width = (int)(screenWidth / zoom);
	height = (int)(screenHeight / zoom);

	focusOn( fx, fy );
}

public void resize( int width, int height ) {
	this.width = width;
	this.height = height;
	screenWidth = (int)(width * zoom);
	screenHeight = (int)(height * zoom);
}

@Override
public void update() {
	super.update();

	if (target != null) {
		focusOn( target );
	}

	if ((shakeTime -= Game.elapsed) > 0) {
		float damping = shakeTime / shakeDuration;
		shakeX = Random.Float( -shakeMagX, +shakeMagX ) * damping;
		shakeY = Random.Float( -shakeMagY, +shakeMagY ) * damping;
	} else {
		shakeX = 0;
		shakeY = 0;
	}

	updateMatrix();
}

public PointF center() {
	return new PointF( width / 2, height / 2 );
}

public boolean hitTest( float x, float y ) {
	return x >= this.x && y >= this.y && x < this.x + screenWidth && y < this.y + screenHeight;
}

public void focusOn( float x, float y ) {
	scroll.set( x - width / 2, y - height / 2 );
}

public void focusOn( PointF point ) {
	focusOn( point.x, point.y );
}

public void focusOn( Visual visual ) {
	focusOn( visual.center() );
}

public PointF screenToCamera( int x, int y ) {
	return new PointF(
		(x - this.x) / zoom + scroll.x,
		(y - this.y) / zoom + scroll.y );
}

public Point cameraToScreen( float x, float y ) {
	return new Point(
		(int)((x - scroll.x) * zoom + this.x),
		(int)((y - scroll.y) * zoom + this.y));
}

public float screenWidth() {
	return width * zoom;
}

public float screenHeight() {
	return height * zoom;
}

protected void updateMatrix() {
	matrix[0] = +zoom * invW2;
	matrix[5] = -zoom * invH2;

	matrix[12] = -1 + x * invW2 - (scroll.x + shakeX) * matrix[0];
	matrix[13] = +1 - y * invH2 - (scroll.y + shakeY) * matrix[5];

}

public void shake( float magnitude, float duration ) {
	shakeMagX = shakeMagY = magnitude;
	shakeTime = shakeDuration = duration;
}
}
