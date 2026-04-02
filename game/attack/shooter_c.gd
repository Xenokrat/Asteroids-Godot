class_name Shooter_C
extends Node2D

@export var bullet_space: Node2D
@export var shooting_point: Marker2D
@export var bullet_scene: PackedScene


func shoot() -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet_space.add_child(bullet)
	bullet.global_position = shooting_point.global_position
	bullet.global_rotation = shooting_point.global_rotation
