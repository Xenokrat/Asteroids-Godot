class_name Ship
extends Node2D

enum GhostLocation {
	TOP,
	DOWN,
	LEFT,
	RIGHT,
}

@export var angualr_speed := 2 * PI
@export var speed := 400
@export var bullet_scene: PackedScene

@onready var ship: = %ShipPlayer

var _ghosts: Dictionary[GhostLocation, Node2D]


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

	for ghost: Node2D in _ghosts.values():
		ghost.rotation = ship.rotation

	_ghosts[GhostLocation.TOP].position = ship.position - Vector2(0, ScreenGlobal.screen_size.y)
	_ghosts[GhostLocation.DOWN].position = ship.position + Vector2(0, ScreenGlobal.screen_size.y)
	_ghosts[GhostLocation.RIGHT].position = ship.position + Vector2(ScreenGlobal.screen_size.x, 0)
	_ghosts[GhostLocation.LEFT].position = ship.position - Vector2(ScreenGlobal.screen_size.x, 0)

	if is_all_points_off_screen(ship):
		for index: GhostLocation in GhostLocation.values():
			if is_all_points_on_screen(_ghosts[index]):
				var ghost_to_swap: Node2D
				ghost_to_swap = _ghosts[index]
				_ghosts[index] = ship
				ship = ghost_to_swap


func _unhandled_input(event: InputEvent) -> void:
	var bullet: Bullet
	var bullet_marker: Marker2D = ship.get_node("BulletMarker")

	if event.is_action_pressed("fire"):
		bullet = bullet_scene.instantiate()
		add_child(bullet)
		bullet.global_position = bullet_marker.global_position
		bullet.rotation = ship.rotation

# TODO: turn this in component


func destroy() -> void:
	queue_free()

#region Screen Wrap
# Should implements this functions in order
# to have a "true" screen wrap
func add_ghosts() -> void:
	add_ghost(GhostLocation.DOWN, Vector2(global_position.x, global_position.y + ScreenGlobal.screen_size.y))
	add_ghost(GhostLocation.TOP, Vector2(global_position.x, global_position.y - ScreenGlobal.screen_size.y))
	add_ghost(GhostLocation.RIGHT, Vector2(global_position.x + ScreenGlobal.screen_size.x, global_position.y))
	add_ghost(GhostLocation.LEFT, Vector2(global_position.x - ScreenGlobal.screen_size.x, global_position.y))


func add_ghost(location: GhostLocation, pos: Vector2) -> void:
	var ghost: CharacterBody2D = ship.duplicate()
	add_child(ghost)
	ghost.global_position = pos
	_ghosts[location] = ghost


func rebuild_ghosts_positions() -> void:
	pass


func is_all_points_off_screen(node: Node2D) -> bool:
	var collision_shape: CollisionShape2D = node.get_node("HitboxComponent/CollisionShape2D")
	return Utils.is_all_points_off_screen(
		node,
		collision_shape,
	)


func is_all_points_on_screen(node: Node2D) -> bool:
	var collision_shape: CollisionShape2D = node.get_node("HitboxComponent/CollisionShape2D")
	return Utils.is_all_points_on_screen(
		node,
		collision_shape,
	)
#endregion
