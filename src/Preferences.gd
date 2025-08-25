#/*
 #* Pixel Dungeon
 #* Copyright (C) 2012-2015 Oleg Dolya
 #*
 #* This program is free software: you can redistribute it and/or modify
 #* it under the terms of the GNU General Public License as published by
 #* the Free Software Foundation, either version 3 of the License, or
 #* (at your option) any later version.
 #*
 #* This program is distributed in the hope that it will be useful,
 #* but WITHOUT ANY WARRANTY; without even the implied warranty of
 #* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 #* GNU General Public License for more details.
 #*
 #* You should have received a copy of the GNU General Public License
 #* along with this program.  If not, see <http://www.gnu.org/licenses/>
 #*/

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
