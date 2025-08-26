class_name Program

var handle: int

func _init() -> void:
	handle = GLES20.glCreateProgram();


func get_handle() -> int:
	return handle;


func attach(shader: Shader) -> void:
	GLES20.glAttachShader( handle, shader.handle() );


func link() -> void:
	GLES20.glLinkProgram( handle );

	var status: PackedInt32Array = [0]

	GLES20.glGetProgramiv( handle, GLES20.GL_LINK_STATUS, status, 0 );
	if (status[0] == GLES20.GL_FALSE):
		printerr( GLES20.glGetProgramInfoLog( handle ) );



func attribute(name: String) -> Attribute:
	return Attribute.new( GLES20.glGetAttribLocation( handle, name ) );


func uniform(name: String) -> Uniform:
	return Uniform.new( GLES20.glGetUniformLocation( handle, name ) );


func use() -> void:
	GLES20.glUseProgram( handle );


func delete() -> void:
	GLES20.glDeleteProgram( handle );


static func create(shaders: Array[Shader]) -> Program:
	var program: Program = Program.new();
	for i: int in range(shaders.length):
		program.attach( shaders[i] );

	program.link();
	return program;
