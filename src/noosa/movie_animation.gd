class_name PAnimation

var delay: float
var frames: Array[RectF] = []
var looped: bool

func _init(fps: int, looped: bool) -> void:
	self.delay = 1 / fps;
	self.looped = looped;


func frames_rect(frames: Array[RectF]) -> Animation:
	self.frames = frames;
	return self;


func frames_film(film: TextureFilm, new_frames: Array[Object]) -> PAnimation:
	self.frames = []
	self.frames.resize(new_frames.length)
	for i: int in range(new_frames.length):
		self.frames[i] = film.get(new_frames[i] );

	return self;


func clone() -> PAnimation:
	return Animation.new( round( 1 / delay ), looped ).frames( frames );
