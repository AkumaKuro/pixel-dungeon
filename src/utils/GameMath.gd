
class_name GameMath

static func speed( speed: float, acc: float ) -> float:

	if (acc != 0):
		speed += acc * Game.elapsed;


	return speed;


static func gate( min: float, value: float, max: float ) -> float:
	if (value < min):
		return min;
	elif (value > max):
		return max;
	else:
		return value;
