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

class_name Bones

const BONES_FILE: String	= "bones.dat";

const LEVEL: String	= "level";
const ITEM: String	= "item";

const depth: int = -1;
const item: Item

enum BelongingType {
	Weapon,
	Armor,
	Ring1,
	Ring2,
	MaxBelongingType
}

static func leave() -> void:

	item = null;
	match randi_range(0, BelongingType.MaxBelongingType):
		BelongingType.Weapon:
			item = Dungeon.hero.belongings.weapon;

		BelongingType.Armor:
			item = Dungeon.hero.belongings.armor;

		BelongingType.Ring1:
			item = Dungeon.hero.belongings.ring1;

		BelongingType.Ring2:
			item = Dungeon.hero.belongings.ring2;


	if (item == null):
		if (Dungeon.gold > 0):
			item = Gold.new( Random.IntRange( 1, Dungeon.gold ) );
		else:
			item = Gold.new( 1 );



	depth = Dungeon.depth;

	var bundle: Bundle = Bundle.new();
	bundle.put( LEVEL, depth );
	bundle.put( ITEM, item );


	var output: OutputStream = Game.instance.openFileOutput( BONES_FILE, Game.MODE_PRIVATE );
	Bundle.write( bundle, output );
	output.close();


static func get() -> Item:
	if (depth == -1):


		var input: InputStream = Game.instance.openFileInput( BONES_FILE ) ;

		var bundle: Bundle = Bundle.read( input );
		input.close();

		depth = bundle.getInt( LEVEL );
		item = bundle.get( ITEM ) as Item

		if !input.error():
			return get();

		else:
			return null;



	if (depth != Dungeon.depth):
		return null

	Game.instance.deleteFile( BONES_FILE );
	depth = 0;

	if (!item.stackable):
		item.cursed = true;
		item.cursedKnown = true;
		if (item.isUpgradable()):
			var lvl: int = (Dungeon.depth - 1) * 3 / 5 + 1;
			if (lvl < item.level()):
				item.degrade( item.level() - lvl );

			item.levelKnown = false;

	if item is Ring:
		(item as Ring).syncGem();


	return item;
