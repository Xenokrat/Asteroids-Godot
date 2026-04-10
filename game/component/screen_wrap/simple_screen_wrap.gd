class_name SimpleScreenWrap
extends Node2D

@export var offset: int
@export var parent: Node2D

@onready var screen_size: Vector2 = get_viewport_rect().size

var is_active := false


func _process(_delta: float) -> void:
	if not is_active:
		return

	if parent.global_position.x < 0 - offset:
		parent.global_position.x = screen_size.x

	if parent.global_position.x > screen_size.x + offset:
		parent.global_position.x = 0

	if parent.global_position.y < 0 - offset:
		parent.global_position.y = screen_size.y

	if parent.global_position.y > screen_size.y + offset:
		parent.global_position.y = 0


func activate() -> void:
	is_active = true
