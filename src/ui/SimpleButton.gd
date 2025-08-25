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

class_name SimpleButton
extends Component

var image: Image

func _init(image: Image) -> void:
	super();

	this.image.copy( image );
	width = image.width;
	height = image.height;


func createChildren() -> void:
	image = Image.new();
	add( image );

	var area: TouchArea = TouchArea.new( image )
	area.onTouchDown.bind(
		func(touch: Touch):
			image.brightness(1.2);
	)

	area.onTouchUp.bind(
		func(touch: Touch):
			image.brightness(1.0);
	)

	area.onClick.bind(
		func(touch: Touch):
			SimpleButton.this.onClick();
	)

	add(area)

#@Override
func layout() -> void:
	image.x = x;
	image.y = y;


func onClick() -> void:
	pass
