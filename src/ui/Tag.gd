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

class_name Tag
extends Button

var r: float
var g: float
var b: float
var bg: NinePatch

var lightness: float = 0;

func _init(color: int) -> void:
	super();

	self.r = (color >> 16) / 255
	self.g = ((color >> 8) & 0xFF) / 255
	self.b = (color & 0xFF) / 255


#@Override
func createChildren() -> void:

	super.createChildren();

	bg = Chrome.get( Chrome.Type.TAG );
	add( bg );


#@Override
func layout() -> void:

	super.layout();

	bg.x = x;
	bg.y = y;
	bg.size( width, height );


func flash() -> void:
	lightness = 1


#@Override
func update() -> void:
	super.update();

	if (visible && lightness > 0.5):
		lightness -= Game.elapsed
		if ((lightness) > 0.5):
			bg.ra = 2 * lightness - 1
			bg.ga = 2 * lightness - 1
			bg.ba = 2 * lightness - 1;
			bg.rm = 2 * r * (1 - lightness);
			bg.gm = 2 * g * (1 - lightness);
			bg.bm = 2 * b * (1 - lightness);
		else:
			bg.hardlight( r, g, b );
