class_name AsteroidOnScreenState
extends State

var ghost: Asteroid


func enter() -> void:
	(parent as Asteroid).off_screen_c.deactivate()


func process_frame(_delta: float) -> State:
	return null
