class_name Shooter_C
extends Node2D

@export var root: Node2D
@export var bullet_scene: PackedScene


func _ready() -> void:
	assert(root.has_method("get_shooter_marker"), "Sooter_C root node should implement `get_shooter_marker`")


func shoot() -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	root.add_child(bullet)
	var marker_node: Marker2D = root.get_shooter_marker()
	print(marker_node)
	bullet.global_position = marker_node.global_position
