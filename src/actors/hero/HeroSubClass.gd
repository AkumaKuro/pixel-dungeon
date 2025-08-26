class_name HeroSubClass
extends Resource

@export var title: String
@export_multiline var desc: String

enum SubClass {
	None,
	Gladiator,
	BERSERKER,
	WARLOCK,
	BATTLEMAGE,
	ASSASSIN,
	FREERUNNER,
	SNIPER,
	WARDEN
}

const SUBCLASS: String = "subClass";

#TODO fix
#func storeInBundle(bundle: Bundle) -> void:
	#bundle.put( SUBCLASS, toString() );
#
#
#static func restoreInBundle(bundle: Bundle) -> HeroSubClass:
	#var value: String = bundle.getString( SUBCLASS );
	#return valueOf( value );
