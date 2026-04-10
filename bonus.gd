extends Node2D

@onready var screen_size: Vector2 = get_viewport_rect().size
@export var speed: int = 200
var velocity: Vector2


func _ready() -> void:
	if global_position.y < screen_size.y:
		velocity = Vector2.DOWN
	else:
		velocity = Vector2.UP


func _process(delta: float) -> void:
	global_position += velocity * speed * delta
