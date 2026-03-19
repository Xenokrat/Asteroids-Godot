extends Node2D

@export var screen_size_buffer: int = 32
@export var offset := 0

@onready var screen_size: Vector2 = get_viewport_rect().size
var parent: Node2D
var is_on_screen: bool = false


func _ready() -> void:
	parent = get_parent()


func _physics_process(_delta: float) -> void:
	if not is_on_screen:
		return
	parent.global_position.x = wrapf(parent.global_position.x, 0 - screen_size_buffer, screen_size.x + screen_size_buffer)
	parent.global_position.y = wrapf(parent.global_position.y, 0 - screen_size_buffer, screen_size.y + screen_size_buffer)


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	is_on_screen = true
