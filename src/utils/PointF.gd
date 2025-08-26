#/*
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

#@SuppressLint("FloatMath")
class_name PointF

const PI2: float	= PI * 2;
const G2R: float	= PI / 180;

var x: float
var y: float

func _init(x: float = 0, y: float = 0) -> void:
	self.x = x;
	self.y = y;


func _init_clone(p: PointF) -> void:
	self.x = p.x;
	self.y = p.y;


func _init_p(p: Point) -> void:
	self.x = p.x;
	self.y = p.y;


func clone() -> PointF:
	return PointF.new(x, y);

func scale(f: float) -> PointF:
	self.x *= f;
	self.y *= f;
	return self;


func invScale( f: float ) -> PointF:
	self.x /= f;
	self.y /= f;
	return self;


func set_float(x: float,y: float ) -> PointF:
	self.x = x;
	self.y = y;
	return self;


func set_point( p: PointF ) -> PointF:
	self.x = p.x;
	self.y = p.y;
	return self;


func set_v(v: float ) -> PointF:
	self.x = v;
	self.y = v;
	return self;


func polar( a: float, l: float ) -> PointF:
	self.x = l * cos( a );
	self.y = l * sin( a );
	return self;


func offset(  dx: float,  dy: float ) -> PointF:
	x += dx;
	y += dy;
	return self;


func offset_point( p: PointF ) -> PointF:
	x += p.x;
	y += p.y;
	return self;


func negate() -> PointF:
	x = -x;
	y = -y;
	return self;


func normalize() -> PointF:
	var l: float = length();
	x /= l;
	y /= l;
	return self;


func floor() -> Point:
	return Point.new(floor(x), floor(y));


func length() -> float:
	return sqrt( x * x + y * y );

static func sum( a: PointF, b: PointF ) -> PointF:
	return PointF.new( a.x + b.x, a.y + b.y );


static func diff(a: PointF,b: PointF ) -> PointF:
	return PointF.new( a.x - b.x, a.y - b.y );


static func inter(  a: PointF,  b: PointF,  d: float ) -> PointF:
	return PointF.new( a.x + (b.x - a.x) * d, a.y + (b.y - a.y) * d );


static func distance(  a: PointF,  b: PointF ) -> float:
	var dx: float = a.x - b.x;
	var dy: float = a.y - b.y;
	return sqrt( dx * dx + dy * dy );


static func angle(  start: PointF,  end: PointF ) -> float:
	return atan2( end.y - start.y, end.x - start.x );


#@Override
func _to_string() -> String:
	return "%s, %s" % [x, y]
