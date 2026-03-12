class_name Bullet
extends Node2D

@export var speed := 800


func _process(delta: float) -> void:
	var velocity := Vector2.UP.rotated(rotation) * speed
	position += velocity * delta
