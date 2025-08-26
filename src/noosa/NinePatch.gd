class_name NinePatch
extends Visual


var texture: SmartTexture

var vertices: PackedFloat32Array
var verticesBuffer: FloatBuffer

var outterF: RectF
var innerF: RectF

var marginLeft: int
var marginRight: int
var marginTop: int
var marginBottom: int

var nWidth: float
var nHeight: float

func _init(tx: Object, margin: int ) -> void:
	_init_n( tx, margin, margin, margin, margin );


func _init_n(tx: Object, left: int, top: int, right: int, bottom: int ) -> void:
	_init_n2( tx, 0, 0, 0, 0, left, top, right, bottom );


func _init_n2(tx: Object, x: int, y: int, w: int, h: int, margin: int ) -> void:
	_init_n3( tx, x, y, w, h, margin, margin, margin, margin );


func _init_n3(tx: Object, x: int, y: int, w: int, h: int, left: int, top: int, right: int, bottom: int ) -> void:
	super( 0, 0, 0, 0 );

	texture = TextureCache.get( tx );
	w = texture.width if w == 0 else w
	h = texture.height if h == 0 else h

	nWidth = w
	width = w;
	nHeight = h
	height = h;

	vertices = []
	vertices.resize(16)
	verticesBuffer = Quad.createSet( 9 );

	marginLeft	= left;
	marginRight	= right;
	marginTop	= top;
	marginBottom= bottom;

	outterF = texture.uvRect( x, y, x + w, y + h );
	innerF = texture.uvRect( x + left, y + top, x + w - right, y + h - bottom );

	updateVertices();


func updateVertices() -> void:

	verticesBuffer.position( 0 );

	var right: float = width - marginRight;
	var bottom: float = height - marginBottom;

	Quad.fill( vertices,
		0, marginLeft, 0, marginTop, outterF.left, innerF.left, outterF.top, innerF.top );
	verticesBuffer.put( vertices );
	Quad.fill( vertices,
		marginLeft, right, 0, marginTop, innerF.left, innerF.right, outterF.top, innerF.top );
	verticesBuffer.put( vertices );
	Quad.fill( vertices,
		right, width, 0, marginTop, innerF.right, outterF.right, outterF.top, innerF.top );
	verticesBuffer.put( vertices );

	Quad.fill( vertices,
		0, marginLeft, marginTop, bottom, outterF.left, innerF.left, innerF.top, innerF.bottom );
	verticesBuffer.put( vertices );
	Quad.fill( vertices,
		marginLeft, right, marginTop, bottom, innerF.left, innerF.right, innerF.top, innerF.bottom );
	verticesBuffer.put( vertices );
	Quad.fill( vertices,
		right, width, marginTop, bottom, innerF.right, outterF.right, innerF.top, innerF.bottom );
	verticesBuffer.put( vertices );

	Quad.fill( vertices,
		0, marginLeft, bottom, height, outterF.left, innerF.left, innerF.bottom, outterF.bottom );
	verticesBuffer.put( vertices );
	Quad.fill( vertices,
		marginLeft, right, bottom, height, innerF.left, innerF.right, innerF.bottom, outterF.bottom );
	verticesBuffer.put( vertices );
	Quad.fill( vertices,
		right, width, bottom, height, innerF.right, outterF.right, innerF.bottom, outterF.bottom );
	verticesBuffer.put( vertices );


func get_marginLeft() -> int:
	return marginLeft;


func get_marginRight() -> int:
	return marginRight;


func get_marginTop() -> int:
	return marginTop;


func get_marginBottom() -> int:
	return marginBottom;


func marginHor() -> int:
	return marginLeft + marginRight;


func marginVer() -> int:
	return marginTop + marginBottom;


func innerWidth() -> float:
	return width - marginLeft - marginRight;


func innerHeight() -> float:
	return height - marginTop - marginBottom;


func innerRight() -> float:
	return width - marginRight;


func innerBottom() -> float:
	return height - marginBottom;


func size( width: float, height: float ) -> void:
	this.width = width;
	this.height = height;
	updateVertices();


#@Override
func draw() -> void:

	super.draw();

	var script: NoosaScript = NoosaScript.get();

	texture.bind();

	script.camera( camera() );

	script.uModel.valueM4( matrix );
	script.lighting(
		rm, gm, bm, am,
		ra, ga, ba, aa );

	script.drawQuadSet( verticesBuffer, 9 );
