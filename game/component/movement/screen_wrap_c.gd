class_name ScreenWrap_C
extends Node2D

@export var parent: Node2D
@export var screen_size_buffer: int = 32
@export var is_active: bool

@onready var screen_size: Vector2 = get_viewport_rect().size


func _ready() -> void:
	assert(parent, "No Parent set for ScreenWrap_C")


func activate() -> void:
	is_active = true


func deactivate() -> void:
	is_active = false


func _physics_process(_delta: float) -> void:
	if not is_active:
		return
	parent.global_position.x = wrapf(parent.global_position.x, 0 - screen_size_buffer, screen_size.x + screen_size_buffer)
	parent.global_position.y = wrapf(parent.global_position.y, 0 - screen_size_buffer, screen_size.y + screen_size_buffer)
