class_name Ship
extends Node2D

@export var angualr_speed := 2 * PI
@export var speed := 400
@export var shooter_c: Shooter_C

@onready var ship: = %ShipPlayer


func _process(_delta: float) -> void:
	var velocity := Vector2.ZERO

	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("thrust"):
		velocity.y -= 1
	if Input.is_action_pressed("brake"):
		velocity.y += 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	if Input.is_action_just_pressed("fire"):
		shooter_c.shoot()

	ship.look_at(get_global_mouse_position())
	ship.rotate(PI / 2)
	ship.velocity = velocity
	ship.move_and_slide()


func destroy() -> void:
	queue_free()


func set_object(new_obj: Node2D) -> void:
	ship = new_obj
	print("set_object", ship)


func get_object() -> Node2D:
	return ship


func get_shooter_marker() -> Marker2D:
	return get_node("ShipPlayer/BulletMarker")
