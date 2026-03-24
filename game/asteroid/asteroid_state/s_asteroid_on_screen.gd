class_name AsteroidOnScreenState
extends State

@export var screen_wrap_c: ScreenWrap_C
var ghost: Asteroid


func enter() -> void:
	(parent as Asteroid).off_screen_c.deactivate()
	(parent as Asteroid).screen_wrap_c.activate()


func process_frame(_delta: float) -> State:
	screen_wrap_c.wrap()
	return null
