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

class_name ResumeButton
extends Tag


var icon: Image

func _init() -> void:
	super( 0xCDD5C0 );

	setSize( 24, 22 );

	visible = false;


#@Override
func createChildren() -> void:
	super.createChildren();

	icon = Icons.get( Icons.RESUME );
	add( icon );


#@Override
func layout() -> void:
	super.layout();

	icon.x = PixelScene.align( PixelScene.uiCamera, x+1 + (width - icon.width) / 2 );
	icon.y = PixelScene.align( PixelScene.uiCamera, y + (height - icon.height) / 2 );


#@Override
func update() -> void:
	var prevVisible: bool = visible;
	visible = (Dungeon.hero.lastAction != null);
	if (visible && !prevVisible):
		flash();


	super.update();


#@Override
func onClick() -> void:
	Dungeon.hero.resume();
