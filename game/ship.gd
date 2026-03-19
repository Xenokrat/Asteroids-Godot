class_name Ship
extends Node2D

@export var angualr_speed := 2 * PI
@export var speed := 400
@export var bullet_scene: PackedScene

@onready var bullet_marker: Marker2D = %BulletMarker
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

	ship.look_at(get_global_mouse_position())
	ship.rotate(PI / 2)
	ship.velocity = velocity
	ship.move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		var bullet: Bullet = bullet_scene.instantiate()
		add_child(bullet)
		bullet.global_position = bullet_marker.global_position
		bullet.rotation = ship.rotation
