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

class_name Challenges

const NO_FOOD: int = 1
const NO_ARMOR: int = 2
const NO_HEALING: int = 4
const NO_HERBALISM: int = 8
const SWARM_INTELLIGENCE: int = 16
const DARKNESS: int = 32
const NO_SCROLLS: int = 64

const NAMES: PackedStringArray = [
	"On diet",
	"Faith is my armor",
	"Pharmacophobia",
	"Barren land",
	"Swarm intelligence",
	"Into darkness",
	"Forbidden runes"
]

const MASKS: PackedInt32Array = [
	NO_FOOD,
	NO_ARMOR,
	NO_HEALING,
	NO_HERBALISM,
	SWARM_INTELLIGENCE,
	DARKNESS,
	NO_SCROLLS
]
