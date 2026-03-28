class_name AsteroidOffScreenState
extends State

@export var asteroid_on_screen: AsteroidOnScreenState
var screen_size: Vector2
var polygon: Polygon2D


func enter() -> void:
	(parent as Asteroid).off_screen_c.activate()
	polygon = parent.polygon


func process_frame(_delta: float) -> State:
	if Utils.is_any_point_on_screen(parent, polygon):
		return asteroid_on_screen
	return null
