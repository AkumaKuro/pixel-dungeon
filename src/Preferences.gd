class_name Preferences

var INSTANCE;

const KEY_LANDSCAPE: String	= "landscape";
const KEY_IMMERSIVE: String	= "immersive";
const KEY_GOOGLE_PLAY: String	= "google_play";
const KEY_SCALE_UP: String		= "scaleup";
const KEY_MUSIC: String		= "music";
const KEY_SOUND_FX: String		= "soundfx";
const KEY_ZOOM: String			= "zoom";
const KEY_LAST_CLASS: String	= "last_class";
const KEY_CHALLENGES: String	= "challenges";
const KEY_DONATED: String		= "donated";
const KEY_INTRO: String		= "intro";
const KEY_BRIGHTNESS: String	= "brightness";

var prefs: SharedPreferences

func get() -> SharedPreferences:
	if (prefs == null):
		prefs = Game.instance.getPreferences( Game.MODE_PRIVATE );

	return prefs;


func getInt(key: String, defValue: int) -> int:
	return get().getInt( key, defValue );


func getBoolean(key: String, defValue: bool) -> bool:
	return get().getBoolean( key, defValue );


func getString(key: String,defValue: String  ) -> String:
	return get().getString( key, defValue );


func put(key: String, value: int) -> void:
	get().edit().putInt( key, value ).commit();


func put_bool(key: String, value: bool) -> void:
	get().edit().putBoolean( key, value ).commit();


func put_string(key: String, value: String) -> void:
	get().edit().putString( key, value ).commit();
