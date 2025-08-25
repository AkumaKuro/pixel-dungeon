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


class_name PseudoPixel
extends Image


func _init() -> void:
	super( TextureCache.createSolid( 0xFFFFFFFF ) );


func _init_all(x: float,y: float, color: int) -> void:

	self();

	self.x = x;
	self.y = y;
	color( color );


func size(w: float,h: float ) -> void:
	scale.set( w, h );


func size(value: float ) -> void:
	scale.set( value );
