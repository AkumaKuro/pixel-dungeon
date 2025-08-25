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

class_name Archs
extends Component


const SCROLL_SPEED: float = 20

var arcsBg: SkinnedBlock
var arcsFg: SkinnedBlock

static var offsB: float = 0;
static var offsF: float = 0;

var reversed: bool = false;

#@Override
func createChildren() -> void:
	arcsBg = SkinnedBlock.new( 1, 1, Assets.ARCS_BG );
	arcsBg.autoAdjust = true;
	arcsBg.offsetTo( 0,  offsB );
	add( arcsBg );

	arcsFg = SkinnedBlock.new( 1, 1, Assets.ARCS_FG );
	arcsFg.autoAdjust = true;
	arcsFg.offsetTo( 0,  offsF );
	add( arcsFg );


#@Override
func layout() -> void:
	arcsBg.size( width, height );
	arcsBg.offset( arcsBg.texture.width / 4 - (width % arcsBg.texture.width) / 2, 0 );

	arcsFg.size( width, height );
	arcsFg.offset( arcsFg.texture.width / 4 - (width % arcsFg.texture.width) / 2, 0 );


#@Override
func update() -> void:

	super.update();

	var shift: float = Game.elapsed * SCROLL_SPEED;
	if (reversed):
		shift = -shift;


	arcsBg.offset( 0, shift );
	arcsFg.offset( 0, shift * 2 );

	offsB = arcsBg.offsetY();
	offsF = arcsFg.offsetY();
