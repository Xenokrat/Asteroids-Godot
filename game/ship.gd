class_name Ship
extends Node2D

@export var angualr_speed := 2 * PI
@export var speed := 400
@export var shooter_c: Shooter_C

@onready var ship: = %ShipPlayer
@onready var shield : StaticBody2D = %Shield
var is_shield_active: bool


func _ready() -> void:
	shield.process_mode = Node.PROCESS_MODE_DISABLED
	is_shield_active = false
	activate_shield()


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

	if Input.is_action_just_pressed("bomb"):
		if PlayerResources.use_bomb():
			shooter_c.shoot_bomb()

	ship.look_at(get_global_mouse_position())
	ship.rotate(PI / 2)
	ship.velocity = velocity
	ship.move_and_slide()

	queue_redraw()


func destroy() -> void:
	queue_free()


func set_object(new_obj: Node2D) -> void:
	ship = new_obj
	print("set_object", ship)


func get_object() -> Node2D:
	return ship


func get_shooter_marker() -> Marker2D:
	return get_node("ShipPlayer/BulletMarker")


func _draw() -> void:
	for i in PlayerResources.bombs:
		draw_circle(ship.position + Vector2(45, -25 + i*20), 8, Color.WHITE, true)
		draw_circle(ship.position + Vector2(45, -25 + i*20), 6, Color.BLACK, true)
	if is_shield_active:
		draw_circle(ship.position, 64, Color.BLUE, true)
		draw_circle(ship.position, 60, Color.BLACK, true)



func deactivate_shield() -> void:
	shield.process_mode = Node.PROCESS_MODE_DISABLED
	is_shield_active = false


func activate_shield() -> void:
	shield.process_mode = Node.PROCESS_MODE_INHERIT
	is_shield_active = true
