class_name AsteroidOnScreenState
extends State

func enter() -> void:
	(parent as Asteroid).off_screen_c.deactivate()
	(parent as Asteroid).screen_wrap_c.activate()
