class_name MovieClip
extends Image

var curAnim: Animation
var curFrame: int
var frameTimer: float
var finished: bool;

var paused: bool = false;

var listener: Listener

func _init() -> void:
	super();


func _init_tx( tx: Object ) -> void:
	super( tx );


#@Override
func update() -> void:
	super.update();
	if (!paused):
		updateAnimation();



func updateAnimation() -> void:
	if (curAnim != null && curAnim.delay > 0 && (curAnim.looped || !finished)):

		var lastFrame: int = curFrame;

		frameTimer += Game.elapsed;
		while (frameTimer > curAnim.delay):
			frameTimer -= curAnim.delay;
			if (curFrame == curAnim.frames.length - 1):
				if (curAnim.looped):
					curFrame = 0;

				finished = true;
				if (listener != null):
					listener.onComplete( curAnim );
					# This check can probably be removed
					if (curAnim == null):
						return;



			else:
				curFrame += 1



		if (curFrame != lastFrame):
			frame( curAnim.frames[curFrame] );





func play(anim: Animation) -> void:
	play( anim, false );


func play_force(anim: Animation, force: bool) -> void:

	if (!force && (curAnim != null) && (curAnim == anim) && (curAnim.looped || !finished)):
		return;


	curAnim = anim;
	curFrame = 0;
	finished = false;

	frameTimer = 0;

	if (anim != null):
		frame( anim.frames[curFrame] );




public interface Listener {
	void onComplete( Animation anim );
}
}
