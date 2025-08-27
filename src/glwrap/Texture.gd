class_name PTexture

const NEAREST: int	= GLMode.Nearest
const LINEAR: int	= GLMode.Linear

const REPEAT: int	= GLMode.Repeat
const MIRROR: int	= GLMode.MirroredRepeat
const CLAMP: int	= GLMode.ClampToEdge

enum GLMode {
	Nearest,
	Linear,
	Repeat,
	MirroredRepeat,
	ClampToEdge
}

var id: int

var premultiplied: bool = false;

func _init() -> void:
	var ids: PackedInt32Array = [0]
	GLES20.glGenTextures( 1, ids, 0 );
	id = ids[0];

	bind();


static func activate(index: int) -> void:
	GLES20.glActiveTexture( GLES20.GL_TEXTURE0 + index );


func bind() -> void:
	GLES20.glBindTexture( GLES20.GL_TEXTURE_2D, id );


func filter(minMode: int,maxMode: int ) -> void:
	bind();
	GLES20.glTexParameterf( GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MIN_FILTER, minMode );
	GLES20.glTexParameterf( GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_MAG_FILTER, maxMode );


func wrap(s: int,t: int ) -> void:
	bind();
	GLES20.glTexParameterf( GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_WRAP_S, s );
	GLES20.glTexParameterf( GLES20.GL_TEXTURE_2D, GLES20.GL_TEXTURE_WRAP_T, t );


func delete() -> void:
	var ids: PackedInt32Array = [id]
	GLES20.glDeleteTextures( 1, ids, 0 );


func bitmap(bitmap: Bitmap) -> void:
	bind();
	GLUtils.texImage2D( GLES20.GL_TEXTURE_2D, 0, bitmap, 0 );

	premultiplied = true;


func pixels(  w: int,  h: int, pixels: PackedInt32Array) -> void:

	bind();

	var imageBuffer: IntBuffer = ByteBuffer.\
		allocateDirect( w * h * 4 ).\
		order( ByteOrder.nativeOrder() ).\
		asIntBuffer();
	imageBuffer.put( pixels );
	imageBuffer.position( 0 );

	GLES20.glTexImage2D(
		GLES20.GL_TEXTURE_2D,
		0,
		GLES20.GL_RGBA,
		w,
		h,
		0,
		GLES20.GL_RGBA,
		GLES20.GL_UNSIGNED_BYTE,
		imageBuffer );


func pixels_byte(w: int,h: int, pixels: PackedByteArray) -> void:

	bind();

	var imageBuffer: ByteBuffer = ByteBuffer.allocateDirect( w * h ).order( ByteOrder.nativeOrder() );
	imageBuffer.put( pixels );
	imageBuffer.position( 0 );

	GLES20.glPixelStorei( GLES20.GL_UNPACK_ALIGNMENT, 1 );

	GLES20.glTexImage2D(
		GLES20.GL_TEXTURE_2D,
		0,
		GLES20.GL_ALPHA,
		w,
		h,
		0,
		GLES20.GL_ALPHA,
		GLES20.GL_UNSIGNED_BYTE,
		imageBuffer );


# If getConfig returns null (unsupported format?), GLUtils.texImage2D works
# incorrectly. In this case we need to load pixels manually
func handMade(bitmap: BitMap, recode: bool) -> void:

	var w: int = bitmap.getWidth();
	var h: int = bitmap.getHeight();

	var pixels: PackedInt32Array = []
	pixels.resize(w * h)
	bitmap.getPixels( pixels, 0, w, 0, 0, w, h );

	# recode - components reordering is needed
	if (recode):
		for i: int in range(pixels.size()):
			var color: int = pixels[i];
			var ag: int = color & 0xFF00FF00;
			var r: int = (color >> 16) & 0xFF;
			var b: int = color & 0xFF;
			pixels[i] = ag | (b << 16) | r;



	pixels( w, h, pixels );

	premultiplied = false;


static func create_bit(bmp: BitMap) -> PTexture:
	var tex: PTexture = PTexture.new();
	tex.bitmap( bmp );

	return tex;


static func create(width: int, height: int, pixels: PackedInt32Array) -> PTexture:
	var tex: PTexture = PTexture.new();
	tex.pixels( width, height, pixels );

	return tex;


static func create_byte( width: int, height: int,pixels: PackedByteArray) -> PTexture:
	var tex: PTexture = PTexture.new();
	tex.pixels_byte( width, height, pixels );

	return tex;
