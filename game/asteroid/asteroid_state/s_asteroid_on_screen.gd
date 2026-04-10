class_name AsteroidOnScreenState
extends State

@export var simple_screen_wrap: SimpleScreenWrap

var angular_velocity: float


func _ready() -> void:
	angular_velocity = randf_range(-PI, PI)


func enter() -> void:
	(parent as Asteroid).off_screen_c.deactivate()
	simple_screen_wrap.activate()


func process_frame(_delta: float) -> State:
	return null


func process_physics(_delta: float) -> State:
	(parent as RigidBody2D).angular_velocity = angular_velocity
	return null
