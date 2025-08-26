class_name CrabSprite
extends MobSprite

func _init():
	super();

	texture( Assets.CRAB );

	var frames: TextureFilm = TextureFilm.new( texture, 16 );

	idle = Animation.new( 5, true );
	idle.frames( frames, 0, 1, 0, 2 );

	run = Animation.new( 15, true );
	run.frames( frames, 3, 4, 5, 6 );

	attack = Animation.new( 12, false );
	attack.frames( frames, 7, 8, 9 );

	die = Animation.new( 12, false );
	die.frames( frames, 10, 11, 12, 13 );

	play( idle );


#@Override
var blood: int = 0xFFFFEA80
