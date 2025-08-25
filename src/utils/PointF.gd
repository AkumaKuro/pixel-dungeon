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

func _init() -> void:
	pass

func _init_all(x: float, y: float) -> void:
	self.x = x;
	self.y = y;


func _init_clone(p: PointF) -> void:
	self.x = p.x;
	self.y = p.y;


func _init_p(p: Point) -> void:
	self.x = p.x;
	self.y = p.y;


func clone() -> PointF:
	return PointF.new(self);

func scale(f: float) -> PointF:
	self.x *= f;
	self.y *= f;
	return self;


public PointF invScale( float f ) {
	this.x /= f;
	this.y /= f;
	return this;
}

public PointF set( float x, float y ) {
	this.x = x;
	this.y = y;
	return this;
}

public PointF set( PointF p ) {
	this.x = p.x;
	this.y = p.y;
	return this;
}

public PointF set( float v ) {
	this.x = v;
	this.y = v;
	return this;
}

public PointF polar( float a, float l ) {
	this.x = l * FloatMath.cos( a );
	this.y = l * FloatMath.sin( a );
	return this;
}

public PointF offset( float dx, float dy ) {
	x += dx;
	y += dy;
	return this;
}

public PointF offset( PointF p ) {
	x += p.x;
	y += p.y;
	return this;
}

public PointF negate() {
	x = -x;
	y = -y;
	return this;
}

func normalize() -> PointF:
	var l: float = length();
	x /= l;
	y /= l;
	return this;


func floor() -> Point:
	return Point.new(floor(x), floor(y));
}

func length() -> float:
	return sqrt( x * x + y * y );

static func sum( PointF a, PointF b ) -> PointF:
	return PointF.new( a.x + b.x, a.y + b.y );
}

static func diff( PointF a, PointF b ) -> PointF:
	return PointF.new( a.x - b.x, a.y - b.y );
}

static func inter( PointF a, PointF b, float d ) -> PointF:
	return PointF.new( a.x + (b.x - a.x) * d, a.y + (b.y - a.y) * d );
}

public static float distance( PointF a, PointF b ) {
	float dx = a.x - b.x;
	float dy = a.y - b.y;
	return FloatMath.sqrt( dx * dx + dy * dy );
}

public static float angle( PointF start, PointF end ) {
	return (float)Math.atan2( end.y - start.y, end.x - start.x );
}

@Override
public String toString() {
	return "" + x + ", " + y;
}
}
