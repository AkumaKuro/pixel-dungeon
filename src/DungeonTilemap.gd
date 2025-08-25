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

class_name DungeonTilemap
extends Tilemap

const SIZE: int = 16

static var instance: DungeonTilemap

func _init() -> void:
	super(
		Dungeon.level.tilesTex(),
		TextureFilm.new( Dungeon.level.tilesTex(), SIZE, SIZE ) );
	map( Dungeon.level.map, Level.WIDTH );

	instance = self

func screenToTile(x: int, y: int) -> int:
	var p: Point = camera().screenToCamera( x, y ).offset( this.point().negate() ).invScale( SIZE ).floor();
	if p.x >= 0 && p.x < Level.WIDTH && p.y >= 0 && p.y < Level.HEIGHT:
		return p.x + p.y * Level.WIDTH
	else:
		return -1;


#@Override
func overlapsPoint(x: float,y: float ) -> bool:
	return true;

func discover(pos: int, oldValue: int) -> void:

	var tile: Image = tile( oldValue );
	tile.point( tileToWorld( pos ) );

	# For bright mode
	tile.rm = rm
	tile.gm = rm
	tile.bm = rm;
	tile.ra = ra
	tile.ga = ra
	tile.ba = ra;
	parent.add( tile );

	var tween: AlphaTweener = AlphaTweener.new( tile, 0, 0.6)
	tween.onComplete.bind(
		func():
			tile.killAndErase();
			killAndErase();
	)

	parent.add(tween)


static func tileToWorld(pos: int) -> PointF:
	return PointF.new( pos % Level.WIDTH, pos / Level.WIDTH).scale( SIZE );

static func tileCenterToWorld(pos: int) -> PointF:
	return PointF.new(
		(pos % Level.WIDTH + 0.5) * SIZE,
		(pos / Level.WIDTH + 0.5) * SIZE
	)


static func tile(index: int) -> Image:
	var img: Image = Image.new( instance.texture );
	img.frame( instance.tileset.get( index ) );
	return img;


#@Override
func overlapsScreenPoint(x: int,y: int ) -> bool:
	return true;
