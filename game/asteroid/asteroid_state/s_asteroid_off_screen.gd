class_name AsteroidOffScreenState
extends State

@export var asteroid_on_screen: AsteroidOnScreenState
var screen_size: Vector2
var polygon: Polygon2D


func enter() -> void:
	(parent as Asteroid).off_screen_c.activate()
	polygon = parent.polygon


func process_frame(_delta: float) -> State:
	var asteroid_polygon: PackedVector2Array = polygon.polygon
	if Utils.is_any_point_on_screen(parent, asteroid_polygon):
		print("is on screen")
		return asteroid_on_screen
	return null
