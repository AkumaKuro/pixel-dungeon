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

class_name Plant
extends Bundlable


var plantName: String

var image: int
var pos: int

var sprite: PlantSprite

func activate(ch: Char) -> void:

	if (ch is Hero && (ch as Hero).subClass == HeroSubClass.WARDEN):
		Buff.affect( ch, Barkskin.class ).level( ch.HT / 3 );


	wither();


func wither() -> void:
	Dungeon.level.uproot( pos );

	sprite.kill();
	if (Dungeon.visible[pos]):
		CellEmitter.get( pos ).burst( LeafParticle.GENERAL, 6 );


	if (Dungeon.hero.subClass == HeroSubClass.WARDEN):
		if (Random.Int( 5 ) == 0):
			Dungeon.level.drop( Generator.random( Generator.Category.SEED ), pos ).sprite.drop();

		if (Random.Int( 5 ) == 0):
			Dungeon.level.drop(Dewdrop.new(), pos ).sprite.drop();




const POS: String = "pos"

#@Override
func restoreFromBundle(bundle: Bundle) -> void:
	pos = bundle.getInt( POS );


#@Override
func storeInBundle(bundle: Bundle) -> void:
	bundle.put( POS, pos );


func desc() -> String:
	return null;
