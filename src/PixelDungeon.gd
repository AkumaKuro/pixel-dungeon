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

class_name PixelDungeon
extends Game


func _init() -> void:
	super( TitleScene.class );

	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.items.scrolls.ScrollOfUpgrade.class,
		"com.watabou.pixeldungeon.items.scrolls.ScrollOfEnhancement" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.actors.blobs.WaterOfHealth.class,
		"com.watabou.pixeldungeon.actors.blobs.Light" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.items.rings.RingOfMending.class,
		"com.watabou.pixeldungeon.items.rings.RingOfRejuvenation" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.items.wands.WandOfReach.class,
		"com.watabou.pixeldungeon.items.wands.WandOfTelekenesis" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.actors.blobs.Foliage.class,
		"com.watabou.pixeldungeon.actors.blobs.Blooming" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.actors.buffs.Shadows.class,
		"com.watabou.pixeldungeon.actors.buffs.Rejuvenation" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.items.scrolls.ScrollOfPsionicBlast.class,
		"com.watabou.pixeldungeon.items.scrolls.ScrollOfNuclearBlast" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.actors.hero.Hero.class,
		"com.watabou.pixeldungeon.actors.Hero" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.actors.mobs.npcs.Shopkeeper.class,
		"com.watabou.pixeldungeon.actors.mobs.Shopkeeper" );
	# 1.6.1
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.items.quest.DriedRose.class,
		"com.watabou.pixeldungeon.items.DriedRose" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.actors.mobs.npcs.MirrorImage.class,
		"com.watabou.pixeldungeon.items.scrolls.ScrollOfMirrorImage$MirrorImage" );
	# 1.6.4
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.items.rings.RingOfElements.class,
		"com.watabou.pixeldungeon.items.rings.RingOfCleansing" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.items.rings.RingOfElements.class,
		"com.watabou.pixeldungeon.items.rings.RingOfResistance" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.items.weapon.missiles.Boomerang.class,
		"com.watabou.pixeldungeon.items.weapon.missiles.RangersBoomerang" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.items.rings.RingOfPower.class,
		"com.watabou.pixeldungeon.items.rings.RingOfEnergy" );
	# 1.7.2
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.plants.Dreamweed.class,
		"com.watabou.pixeldungeon.plants.Blindweed" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.plants.Dreamweed.Seed.class,
		"com.watabou.pixeldungeon.plants.Blindweed$Seed" );
	# 1.7.4
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.items.weapon.enchantments.Shock.class,
		"com.watabou.pixeldungeon.items.weapon.enchantments.Piercing" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.items.weapon.enchantments.Shock.class,
		"com.watabou.pixeldungeon.items.weapon.enchantments.Swing" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.items.scrolls.ScrollOfEnchantment.class,
		"com.watabou.pixeldungeon.items.scrolls.ScrollOfWeaponUpgrade" );
	# 1.7.5
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.items.scrolls.ScrollOfEnchantment.class,
		"com.watabou.pixeldungeon.items.Stylus" );
	# 1.8.0
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.actors.mobs.FetidRat.class,
		"com.watabou.pixeldungeon.actors.mobs.npcs.Ghost$FetidRat" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.plants.Rotberry.class,
		"com.watabou.pixeldungeon.actors.mobs.npcs.Wandmaker$Rotberry" );
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.plants.Rotberry.Seed.class,
		"com.watabou.pixeldungeon.actors.mobs.npcs.Wandmaker$Rotberry$Seed" );
	# 1.9.0
	com.watabou.utils.Bundle.addAlias(
		com.watabou.pixeldungeon.items.wands.WandOfReach.class,
		"com.watabou.pixeldungeon.items.wands.WandOfTelekinesis" );


#@Override
func onCreate(savedInstanceState: Bundle) -> void:
	super.onCreate( savedInstanceState );

	updateImmersiveMode();

	var metrics: DisplayMetrics = DisplayMetrics.new();
	instance.getWindowManager().getDefaultDisplay().getMetrics( metrics );
	var landscape: bool = metrics.widthPixels > metrics.heightPixels;

	if (Preferences.INSTANCE.getBoolean( Preferences.KEY_LANDSCAPE, false ) != landscape):
		landscape( !landscape );


	Music.INSTANCE.enable( music() );
	Sample.INSTANCE.enable( soundFx() );

	Sample.INSTANCE.load(
		Assets.SND_CLICK,
		Assets.SND_BADGE,
		Assets.SND_GOLD,

		Assets.SND_DESCEND,
		Assets.SND_STEP,
		Assets.SND_WATER,
		Assets.SND_OPEN,
		Assets.SND_UNLOCK,
		Assets.SND_ITEM,
		Assets.SND_DEWDROP,
		Assets.SND_HIT,
		Assets.SND_MISS,
		Assets.SND_EAT,
		Assets.SND_READ,
		Assets.SND_LULLABY,
		Assets.SND_DRINK,
		Assets.SND_SHATTER,
		Assets.SND_ZAP,
		Assets.SND_LIGHTNING,
		Assets.SND_LEVELUP,
		Assets.SND_DEATH,
		Assets.SND_CHALLENGE,
		Assets.SND_CURSED,
		Assets.SND_EVOKE,
		Assets.SND_TRAP,
		Assets.SND_TOMB,
		Assets.SND_ALERT,
		Assets.SND_MELD,
		Assets.SND_BOSS,
		Assets.SND_BLAST,
		Assets.SND_PLANT,
		Assets.SND_RAY,
		Assets.SND_BEACON,
		Assets.SND_TELEPORT,
		Assets.SND_CHARMS,
		Assets.SND_MASTERY,
		Assets.SND_PUFF,
		Assets.SND_ROCKS,
		Assets.SND_BURNING,
		Assets.SND_FALLING,
		Assets.SND_GHOST,
		Assets.SND_SECRET,
		Assets.SND_BONES,
		Assets.SND_BEE,
		Assets.SND_DEGRADE,
		Assets.SND_MIMIC );


#@Override
func onWindowFocusChanged(hasFocus: bool) -> void:

	super.onWindowFocusChanged( hasFocus );

	if (hasFocus):
		updateImmersiveMode();



static func switchNoFade(c: PixelScene) -> void:
	PixelScene.noFade = true;
	switchScene( c );


#/*
 #* ---> Prefernces
 #*/

static func landscape_v(value: bool) -> void:
	Game.instance.setRequestedOrientation(
		ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE if value else
		ActivityInfo.SCREEN_ORIENTATION_PORTRAIT );
	Preferences.INSTANCE.put( Preferences.KEY_LANDSCAPE, value );


static func landscape() -> bool:
	return width > height;


# *** IMMERSIVE MODE ****

static var immersiveModeChanged: bool = false;

#@SuppressLint("NewApi")
static func immerse(value: bool) -> void:
	Preferences.INSTANCE.put( Preferences.KEY_IMMERSIVE, value );

	var runnable: Runnable = Runnable.new()
	runnable.run.bind(
		func():
			updateImmersiveMode();
			immersiveModeChanged = true;
	)
	instance.runOnUiThread(runnable)


#@Override
func onSurfaceChanged(gl: GL10, width: int, height: int ) -> void:
	super.onSurfaceChanged( gl, width, height );

	if (immersiveModeChanged):
		requestedReset = true;
		immersiveModeChanged = false;



#@SuppressLint("NewApi")
static func updateImmersiveMode() -> void:
	if (android.os.Build.VERSION.SDK_INT >= 19):
		if true:
			# TODO Sometime NullPointerException happens here
			instance.getWindow().getDecorView().setSystemUiVisibility(

				View.SYSTEM_UI_FLAG_LAYOUT_STABLE |
				View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION |
				View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN |
				View.SYSTEM_UI_FLAG_HIDE_NAVIGATION |
				View.SYSTEM_UI_FLAG_FULLSCREEN |
				View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
				if immersed() else
				0 );
		else:
			printerr('Something went wrong here')




static func immersed() -> bool:
	return Preferences.INSTANCE.getBoolean( Preferences.KEY_IMMERSIVE, false );


# *****************************

static func scaleUp_v(value: bool) -> void:
	Preferences.INSTANCE.put( Preferences.KEY_SCALE_UP, value );
	switchScene( TitleScene.class );


static func scaleUp() -> bool:
	return Preferences.INSTANCE.getBoolean( Preferences.KEY_SCALE_UP, true );


static func zoom_v(value: int) -> void:
	Preferences.INSTANCE.put( Preferences.KEY_ZOOM, value );


static func zoom() -> int:
	return Preferences.INSTANCE.getInt( Preferences.KEY_ZOOM, 0 );


static func music_v(value: bool) -> void:
	Music.INSTANCE.enable( value );
	Preferences.INSTANCE.put( Preferences.KEY_MUSIC, value );


static func music() -> bool:
	return Preferences.INSTANCE.getBoolean( Preferences.KEY_MUSIC, true );

static func soundFx_v(value: bool) -> void:
	Sample.INSTANCE.enable( value );
	Preferences.INSTANCE.put( Preferences.KEY_SOUND_FX, value );


static func soundFx() -> bool:
	return Preferences.INSTANCE.getBoolean( Preferences.KEY_SOUND_FX, true );


static func brightness_v(value: bool) -> void:
	Preferences.INSTANCE.put( Preferences.KEY_BRIGHTNESS, value );
	if (scene() is GameScene):
		(scene() as GameScene).brightness( value );



static func brightness() -> bool:
	return Preferences.INSTANCE.getBoolean( Preferences.KEY_BRIGHTNESS, false );


static func donated_v(value: String) -> void:
	Preferences.INSTANCE.put( Preferences.KEY_DONATED, value );


static func donated() -> String:
	return Preferences.INSTANCE.getString( Preferences.KEY_DONATED, "" );


static func lastClass_v(value: int) -> void:
	Preferences.INSTANCE.put( Preferences.KEY_LAST_CLASS, value );


static func lastClass() -> int:
	return Preferences.INSTANCE.getInt( Preferences.KEY_LAST_CLASS, 0 );


static func challenges_v(value: int) -> void:
	Preferences.INSTANCE.put( Preferences.KEY_CHALLENGES, value );


static func challenges() -> int:
	return Preferences.INSTANCE.getInt( Preferences.KEY_CHALLENGES, 0 );


static func intro_v(value: bool) -> void:
	Preferences.INSTANCE.put( Preferences.KEY_INTRO, value );


static func intro() -> bool:
	return Preferences.INSTANCE.getBoolean( Preferences.KEY_INTRO, true );


#/*
 #* <--- Preferences
 #*/

static func reportException(tr: Throwable) -> void:
	Log.e( "PD", Log.getStackTraceString( tr ) );
