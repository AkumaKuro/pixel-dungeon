class_name PShader

const VERTEX: int		= GLES20.GL_VERTEX_SHADER;
const FRAGMENT: int	= GLES20.GL_FRAGMENT_SHADER;

class GLES20:
	const GL_VERTEX_SHADER: int = 0
	const GL_FRAGMENT_SHADER: int = 2
	const GL_COMPILE_STATUS: int = 3
	const GL_FALSE: int = 4
	static func glCreateShader(type: int) -> GLES20:
		return GLES20.new()

	static func glShaderSource(handle: GLES20, src: String) -> void:
		pass

	static func glCompileShader(handle: GLES20) -> void:
		pass

	static func glDeleteShader(handle: GLES20) -> void:
		pass

	static func glGetShaderiv( handle: GLES20, status: int, status_data: PackedInt32Array, mode: int) -> void:
		pass

	static func glGetShaderInfoLog(handle: GLES20) -> String:
		return ''

enum ShaderType {
	VERTEX,
	FRAGMENT
}

var handle: GLES20

func _init(type: int) -> void:
	handle = GLES20.glCreateShader( type );


func get_handle() -> GLES20:
	return handle;


func source(src: String) -> void:
	GLES20.glShaderSource( handle, src );


func compile() -> void:
	GLES20.glCompileShader( handle );

	var status: PackedInt32Array = [0]
	GLES20.glGetShaderiv( handle, GLES20.GL_COMPILE_STATUS, status, 0 );
	if (status[0] == GLES20.GL_FALSE):
		printerr( GLES20.glGetShaderInfoLog( handle ) );



func delete() -> void:
	GLES20.glDeleteShader( handle );


static func createCompiled(type: int, src: String) -> PShader:
	var shader: PShader = PShader.new( type );
	shader.source( src );
	shader.compile();
	return shader;
