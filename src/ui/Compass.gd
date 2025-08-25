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

class_name Compass
extends Image


const RAD_2_G: float	= 180 / PI
const RADIUS: float	= 12;

var cell: int
var cellCenter: PointF

var lastScroll: PointF = PointF.new();

func _init(cell: int) -> void:

	super();
	copy( Icons.COMPASS.get() );
	origin.set( width / 2, RADIUS );

	this.cell = cell;
	cellCenter = DungeonTilemap.tileCenterToWorld( cell );
	visible = false;


#@Override
func update() -> void:
	super.update();

	if (!visible):
		visible = Dungeon.level.visited[cell] || Dungeon.level.mapped[cell];


	if (visible):
		var scroll: PointF = Camera.main.scroll;
		if (!scroll.equals( lastScroll )):
			lastScroll.set( scroll );
			var center: PointF = Camera.main.center().offset( scroll );
			angle = Math.atan2( cellCenter.x - center.x, center.y - cellCenter.y ) * RAD_2_G;
