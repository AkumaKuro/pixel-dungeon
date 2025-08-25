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

class_name Statistics

static var goldCollected: int
static var deepestFloor: int
static var enemiesSlain: int
static var foodEaten: int
static var potionsCooked: int
static var piranhasKilled: int
static var nightHunt: int
static var ankhsUsed: int

static var duration: float

static var qualifiedForNoKilling: bool = false;
static var completedWithNoKilling: bool = false;

static var amuletObtained: bool = false;

static func reset() -> void:

	goldCollected	= 0;
	deepestFloor	= 0;
	enemiesSlain	= 0;
	foodEaten		= 0;
	potionsCooked	= 0;
	piranhasKilled	= 0;
	nightHunt		= 0;
	ankhsUsed		= 0;

	duration	= 0;

	qualifiedForNoKilling = false;

	amuletObtained = false;



const GOLD: String		= "score";
const DEEPEST: String		= "maxDepth";
const SLAIN: String		= "enemiesSlain";
const FOOD: String		= "foodEaten";
const ALCHEMY: String		= "potionsCooked";
const PIRANHAS: String	= "priranhas";
const NIGHT: String		= "nightHunt";
const ANKHS: String		= "ankhsUsed";
const DURATION: String	= "duration";
const AMULET: String		= "amuletObtained";

static func storeInBundle(bundle: Bundle) -> void:
	bundle.put( GOLD,		goldCollected );
	bundle.put( DEEPEST,	deepestFloor );
	bundle.put( SLAIN,		enemiesSlain );
	bundle.put( FOOD,		foodEaten );
	bundle.put( ALCHEMY,	potionsCooked );
	bundle.put( PIRANHAS,	piranhasKilled );
	bundle.put( NIGHT,		nightHunt );
	bundle.put( ANKHS,		ankhsUsed );
	bundle.put( DURATION,	duration );
	bundle.put( AMULET,		amuletObtained );


static func restoreFromBundle(bundle: Bundle) -> void:
	goldCollected	= bundle.getInt( GOLD );
	deepestFloor	= bundle.getInt( DEEPEST );
	enemiesSlain	= bundle.getInt( SLAIN );
	foodEaten		= bundle.getInt( FOOD );
	potionsCooked	= bundle.getInt( ALCHEMY );
	piranhasKilled	= bundle.getInt( PIRANHAS );
	nightHunt		= bundle.getInt( NIGHT );
	ankhsUsed		= bundle.getInt( ANKHS );
	duration		= bundle.getFloat( DURATION );
	amuletObtained	= bundle.getBoolean( AMULET );
