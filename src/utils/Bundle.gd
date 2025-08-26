class_name Bundle


static var CLASS_NAME: String = "__className";

static var aliases: Dictionary[String, String] = {}

var data: JSON

func _init(data: JSON = null) -> void:
	if !data:
		self.data = JSON.new()
	else:
		self.data = data;


func toString() -> String:
	return data.toString();


func isNull() -> bool:
	return data == null;


func fields() -> PackedStringArray:
	var result: PackedStringArray = []

	result = data.keys()
	return result;


func contains(key: String) -> bool:
	return !data.isNull( key );


func getBoolean(key: String) -> bool:
	return data.optBoolean( key );


func getInt(key: String) -> int:
	return data.optInt( key );


func getFloat(key: String) -> float:
	return data.optDouble( key );


func getString(key: String) -> String:
	return data.optString( key );


func getBundle(key: String) -> Bundle:
	return Bundle.new( data.optJSONObject( key ) );


func get_bundle() -> Bundlable:
	var clName: String = getString( CLASS_NAME );
	if (aliases.find_key( clName )):
		clName = aliases.get( clName );

	#TODO fix
	#var cl: Class = Class.forName( clName );
	#if (cl != null):
		#var object: Bundlable = cl.newInstance() as Bundlable
		#object.restoreFromBundle( self );
		#return object;
	#else:
		#return null;
	return null



func get_bundle_from_key( key: String) -> Bundlable:
	return getBundle( key ).get();


# public <E extends Enum<E>> E
func getEnum(key: String, enumClass ):
	return Enum.valueOf( enumClass, data.getString( key ) )

func getIntArray(key: String) -> PackedInt32Array:
	var array: JSONArray = data.getJSONArray( key );
	var length: int = array.length();
	var result: PackedInt32Array = []
	result.resize(length)

	for i: int in range(length):
		result[i] = array.getInt( i );

	return result;

func getBooleanArray(key: String) -> PackedByteArray:

	var array: JSONArray = data.getJSONArray( key );
	var length: int = array.length();
	var result: Array[bool] = []
	result.resize(length)
	for i: int in range(length):
		result[i] = array.getBoolean( i );

	return result;

func getStringArray(key: String) -> PackedStringArray:
	var array: JSONArray = data.getJSONArray( key );
	var length: int = array.length();
	var result: PackedStringArray = []
	result.resize(length)
	for i: int in range(length):
		result[i] = array.getString( i );

	return result;


func getCollection(key: String) -> Collection[Bundlable]:

	var list: Array[Bundlable] = []

	var array: JSONArray = data.getJSONArray( key );
	for i: int in range(array.length()):
		list.add(Bundle.new( array.getJSONObject( i ) ).get() );

	return list;


func put_bool(key: String, value: bool) -> void:
	data.put( key, value );

func put_int(key: String, value: int ) -> void:
	data.put( key, value );




func put_float(key: String, value: float ) -> void:
	data.put( key, value );


func put_string(key: String, value: String) -> void:
	data.put( key, value );


func put_bundle(key: String, bundle: Bundle) -> void:
	data.put( key, bundle.data );


func put_object(key: String, object: Bundlable) -> void:
	if (object != null):
		var bundle: Bundle = Bundle.new();
		bundle.put( CLASS_NAME, object.getClass().getName() );
		object.storeInBundle( bundle );
		data.put( key, bundle.data );

func put_enum(key: String, value: int) -> void:
	if (value != null):
		data.put( key, value.name() );

func put_int_array(key: String, array: PackedInt32Array) -> void:
	data.put( key, array );

func put_ba(key: String, array: Array[bool]) -> void:

	var jsonArray: JSONArray = JSONArray.new();
	for i: int in range(array.length):
		jsonArray.put( i, array[i] );

	data.put( key, jsonArray );


func put_sa(key: String, array: PackedStringArray ) -> void:

	var jsonArray: JSONArray = JSONArray.new();
	for i: int in range(array.length):
		jsonArray.put( i, array[i] );

	data.put( key, jsonArray );


func put_c(key: String, collection: Collection) -> void:
	var array: JSONArray = JSONArray.new();
	for object: Bundlable in collection:
		var bundle: Bundle = Bundle.new();
		bundle.put( CLASS_NAME, object.getClass().getName() );
		object.storeInBundle( bundle );
		array.put( bundle.data );

	data.put( key, array );

static func read(stream: InputStream) -> Bundle:


	var reader: BufferedReader = BufferedReader.new( InputStreamReader.new( stream ) );

	var all: StringBuilder = StringBuilder.new();
	var line: String = reader.readLine();
	while (line != null):
		all.append( line );
		line = reader.readLine();


	var json: JSONObject = JSONTokener.new( all.toString() ).nextValue() as JSONObject
	reader.close();

	return Bundle.new( json );


static func read_bytes(bytes: PackedByteArray) -> Bundle:
	var json: JSONObject = JSONTokener.new(String( bytes )).nextValue() as JSONObject
	return Bundle.new( json );

static func write(bundle: Bundle, stream: OutputStream) -> bool:
	var writer: BufferedWriter = BufferedWriter.new(OutputStreamWriter.new(stream))
	writer.write( bundle.data.toString() );
	writer.close();

	return true;

static func addAlias(cl, alias: String) -> void:
	aliases.put_string( alias, cl.getName() );
