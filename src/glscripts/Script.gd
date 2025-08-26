class_name PScript
extends Program

static var all: Dictionary[String,PScript] = {}

static var curScript: PScript = null;
static var curScriptClass: String = null;

#@SuppressWarnings("unchecked")
static func use(c: String) -> PScript:
	if (c != curScriptClass):
		var script: PScript = all.get( c );
		if (script == null):
			script = c.newInstance();

			all.put( c, script );

		if (curScript != null):
			curScript.unuse();

		curScript = script;
		curScriptClass = c;
		curScript.use();

	return curScript;


static func reset() -> void:
	for script: PScript in all.values():
		script.delete();

	all.clear();

	curScript = null;
	curScriptClass = null;


func compile(src: String) -> void:

	var srcShaders: PackedStringArray = src.split( "//\n" );
	attach( Shader.createCompiled( Shader.VERTEX, srcShaders[0] ) );
	attach( Shader.createCompiled( Shader.FRAGMENT, srcShaders[1] ) );
	link();

func unuse() -> void:
	pass
