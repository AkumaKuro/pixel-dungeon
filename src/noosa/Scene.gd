class_name Scene
extends Group


var keyListener: Listener #[Keys.Key]

func create() -> void:
	keyListener = Listener.new() #<Keys.Key>
	Keys.event.add(keyListener)
	keyListener.onSignal.bind(
		func(key: Keys.Key):
			if (Game.instance != null && key.pressed):
				match key.code:
					Keys.BACK:
						onBackPressed();

					Keys.MENU:
						onMenuPressed();
	)


#@Override
func destroy() -> void:
	Keys.event.remove( keyListener );
	super.destroy();


func pause() -> void:
	pass


func resume() -> void:
	pass


#
func update() -> void:
	super.update();


#
func camera() -> Camera:
	return Camera.main;


func onBackPressed() -> void:
	Game.instance.finish()


func onMenuPressed() -> void:
	pass
