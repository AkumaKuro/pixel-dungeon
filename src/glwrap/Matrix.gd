class_name Matrix

const G2RAD: float = 0.01745329251994329576923690768489

static func clone(m: PackedFloat32Array) -> PackedFloat32Array:

	var n: int = m.size()
	var res: PackedFloat32Array = []
	res.resize(n)
	while (n > 0):
		n -= 1
		res[n] = m[n];


	return res;


static func copy(src: PackedFloat32Array,dst: PackedFloat32Array ) -> void:

	var n: int = src.size()
	while (n > 0):
		n -= 1
		dst[n] = src[n];



static func setIdentity(m: PackedFloat32Array) -> void:
	for i: int in range(16):
		m[i] = 0

	for i: int in range(0, 16, 5):
		m[i] = 1



static func rotate(m: PackedFloat32Array, a: float) -> void:
	a *= G2RAD;
	var sin_res: float = sin( a );
	var cos_res: float = cos( a );
	var m0: float = m[0];
	var m1: float = m[1];
	var m4: float = m[4];
	var m5: float = m[5];
	m[0] = m0 * cos_res + m4 * sin_res;
	m[1] = m1 * cos_res + m5 * sin_res;
	m[4] = -m0 * sin_res + m4 * cos_res;
	m[5] = -m1 * sin_res + m5 * cos_res;


static func skewX(m: PackedFloat32Array, a: float ) -> void:
	var t: float = tan( a * G2RAD );
	m[4] -= m[0] * t;
	m[5] -= m[1] * t;


static func skewY(m: PackedFloat32Array, a: float ) -> void:
	var t: float = tan( a * G2RAD );
	m[0] += m[4] * t;
	m[1] += m[5] * t;


static func scale(m: PackedFloat32Array, x: float, y: float ) -> void:
	m[0] *= x;
	m[1] *= x;
	m[2] *= x;
	m[3] *= x;
	m[4] *= y;
	m[5] *= y;
	m[6] *= y;
	m[7] *= y;


static func translate(m: PackedFloat32Array, x: float, y: float ) -> void:
	m[12] += m[0] * x + m[4] * y;
	m[13] += m[1] * x + m[5] * y;


static func multiply( left: PackedFloat32Array, right: PackedFloat32Array, result: PackedFloat32Array ) -> void:
	multiplyMM( result, 0, left, 0, right, 0 );

# Multiplies two matrices lhs and rhs (stored as flat arrays of floats) and stores result in result array.
# The matrices are assumed to be 4x4 for this example; adjust sizes as needed.
static func multiplyMM(result: PackedFloat32Array, resultOffset: int, lhs: PackedFloat32Array, lhsOffset: int, rhs: PackedFloat32Array, rhsOffset: int) -> void:
	var size: int = 4  # Assuming 4x4 matrices (adjust as needed)
	for i: int in range(size):
		for j: int in range(size):
			var sum = 0.0
			for k in range(size):
				var lhs_index: float = lhsOffset + i * size + k
				var rhs_index: float = rhsOffset + k * size + j
				sum += lhs[lhs_index] * rhs[rhs_index]
			result[resultOffset + i * size + j] = sum
