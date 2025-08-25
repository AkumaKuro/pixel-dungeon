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

class_name Icons

enum Icon {
	SKULL,
	BUSY,
	COMPASS,
	PREFS,
	WARNING,
	TARGET,
	WATA,
	WARRIOR,
	MAGE,
	ROGUE,
	HUNTRESS,
	CLOSE,
	DEPTH,
	SLEEP,
	ALERT,
	SUPPORT,
	SUPPORTED,
	BACKPACK,
	SEED_POUCH,
	SCROLL_HOLDER,
	WAND_HOLSTER,
	KEYRING,
	CHECKED,
	UNCHECKED,
	EXIT,
	CHALLENGE_OFF,
	CHALLENGE_ON,
	RESUME
}



var icon: Icon


func get_icons() -> Texture2D:
	return get_icon( self );


static func get_icon(type: Icons) -> Texture2D:
	var icon: Texture2D = Assets.ICONS.duplicate()
	match type:
		Icon.SKULL:
			icon.frame( icon.texture.uvRect( 0, 0, 8, 8 ) );

		Icon.BUSY:
			icon.frame( icon.texture.uvRect( 8, 0, 16, 8 ) );

		Icon.COMPASS:
			icon.frame( icon.texture.uvRect( 0, 8, 7, 13 ) );

		Icon.PREFS:
			icon.frame( icon.texture.uvRect( 30, 0, 46, 16 ) );

		Icon.WARNING:
			icon.frame( icon.texture.uvRect( 46, 0, 58, 12 ) );

		Icon.TARGET:
			icon.frame( icon.texture.uvRect( 0, 13, 16, 29 ) );

		Icon.WATA:
			icon.frame( icon.texture.uvRect( 30, 16, 45, 26 ) );

		Icon.WARRIOR:
			icon.frame( icon.texture.uvRect( 0, 29, 16, 45 ) );

		Icon.MAGE:
			icon.frame( icon.texture.uvRect( 16, 29, 32, 45 ) );

		Icon.ROGUE:
			icon.frame( icon.texture.uvRect( 32, 29, 48, 45 ) );

		Icon.HUNTRESS:
			icon.frame( icon.texture.uvRect( 48, 29, 64, 45 ) );

		Icon.CLOSE:
			icon.frame( icon.texture.uvRect( 0, 45, 13, 58 ) );

		Icon.DEPTH:
			icon.frame( icon.texture.uvRect( 45, 12, 54, 20 ) );

		Icon.SLEEP:
			icon.frame( icon.texture.uvRect( 13, 45, 22, 53 ) );

		Icon.ALERT:
			icon.frame( icon.texture.uvRect( 22, 45, 30, 53 ) );

		Icon.SUPPORT:
			icon.frame( icon.texture.uvRect( 30, 45, 46, 61 ) );

		Icon.SUPPORTED:
			icon.frame( icon.texture.uvRect( 46, 45, 62, 61 ) );

		Icon.BACKPACK:
			icon.frame( icon.texture.uvRect( 58, 0, 68, 10 ) );

		Icon.SCROLL_HOLDER:
			icon.frame( icon.texture.uvRect( 68, 0, 78, 10 ) );

		Icon.SEED_POUCH:
			icon.frame( icon.texture.uvRect( 78, 0, 88, 10 ) );

		Icon.WAND_HOLSTER:
			icon.frame( icon.texture.uvRect( 88, 0, 98, 10 ) );

		Icon.KEYRING:
			icon.frame( icon.texture.uvRect( 64, 29, 74, 39 ) );

		Icon.CHECKED:
			icon.frame( icon.texture.uvRect( 54, 12, 66, 24 ) );

		Icon.UNCHECKED:
			icon.frame( icon.texture.uvRect( 66, 12, 78, 24 ) );

		Icon.EXIT:
			icon.frame( icon.texture.uvRect( 98, 0, 114, 16 ) );

		Icon.CHALLENGE_OFF:
			icon.frame( icon.texture.uvRect( 78, 16, 102, 40 ) );

		Icon.CHALLENGE_ON:
			icon.frame( icon.texture.uvRect( 102, 16, 126, 40 ) );

		Icon.RESUME:
			icon.frame( icon.texture.uvRect( 114, 0, 126, 11 ) );


	return icon;


static func get_hero_class(cl: HeroClass) -> Texture2D:
	match cl:
		Icon.WARRIOR:
			return get_icon(Icon.WARRIOR);
		Icon.MAGE:
			return get_icon(Icon.MAGE);
		Icon.ROGUE:
			return get_icon(Icon.ROGUE);
		Icon.HUNTRESS:
			return get_icon(Icon.HUNTRESS);
		_:
			return null;
