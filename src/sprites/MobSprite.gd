class_name MobSprite
extends CharSprite

const FADE_TIME: float = 3
const FALL_TIME: float = 1

#@Override
public void update() {
	sleeping = ch != null && ((Mob)ch).state == ((Mob)ch).SLEEPEING;
	super.update();
}

#@Override
public void onComplete( Animation anim ) {

	super.onComplete( anim );

	if (anim == die) {
		parent.add( new AlphaTweener( this, 0, FADE_TIME ) {
			@Override
			protected void onComplete() {
				MobSprite.this.killAndErase();
				parent.erase( this );
			};
		} );
	}
}

public void fall() {

	origin.set( width / 2, height - DungeonTilemap.SIZE / 2 );
	angularSpeed = Random.Int( 2 ) == 0 ? -720 : 720;

	parent.add( new ScaleTweener( this, new PointF( 0, 0 ), FALL_TIME ) {
		@Override
		protected void onComplete() {
			MobSprite.this.killAndErase();
			parent.erase( this );
		};
		@Override
		protected void updateValues( float progress ) {
			super.updateValues( progress );
			am = 1 - progress;
		}
	} );
}
}
