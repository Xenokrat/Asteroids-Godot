class_name Ship
extends Node2D

@export var angualr_speed := 2 * PI
@export var speed := 400
@export var bullet_scene: PackedScene

@onready var bullet_marker: Marker2D = %BulletMarker
@onready var ship: = %ShipPlayer

var _ghosts: Array[CharacterBody2D]


func _ready() -> void:
	add_ghosts()


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

	for ghost in _ghosts:
		ghost.rotation = ship.rotation
		ghost.velocity = ship.velocity
		ghost.move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	var bullet: Bullet
	if event.is_action_pressed("fire"):
		bullet = bullet_scene.instantiate()
		add_child(bullet)
		bullet.global_position = bullet_marker.global_position
		bullet.rotation = ship.rotation

		for ghost in _ghosts:
			bullet = bullet_scene.instantiate()
			var marker: Marker2D = ghost.get_node("BulletMarker")
			add_child(bullet)
			bullet.global_position = marker.global_position
			bullet.rotation = ship.rotation


func add_ghosts() -> void:
	_add_ghost(Vector2(global_position.x, global_position.y + ScreenGlobal.screen_size.y))
	_add_ghost(Vector2(global_position.x, global_position.y - ScreenGlobal.screen_size.y))
	_add_ghost(Vector2(global_position.x + ScreenGlobal.screen_size.x, global_position.y))
	_add_ghost(Vector2(global_position.x - ScreenGlobal.screen_size.x, global_position.y))


func _add_ghost(pos: Vector2) -> void:
	var ghost: CharacterBody2D = ship.duplicate()
	add_child(ghost)
	ghost.global_position = pos
	_ghosts.append(ghost)


func destroy() -> void:
	queue_free()
