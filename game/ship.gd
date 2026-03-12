extends Node2D

@export var angualr_speed := 2 * PI
@export var speed := 400


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	var velocity := Vector2.ZERO

	if Input.is_action_pressed("rotate_left"):
		rotation -= angualr_speed * delta

	if Input.is_action_pressed("rotate_right"):
		rotation += angualr_speed * delta

	if Input.is_action_pressed("thrust"):
		velocity = Vector2.UP.rotated(rotation) * speed
		position += velocity * delta
