class_name ScreenWrap_C
extends Node2D

const GHOST_LAYER_MASK := 5

@export var object: Node2D
@export var object_shape: Node2D

enum GhostLocation {
	VERTICAL,
	HORIZONTAL,
	DIAGONAL,
}
enum GhostConfiguration {
	UPPER_LEFT,
	UPPER_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
}

@export var ghosts_current_configuration: GhostConfiguration

@onready var screen_size := get_viewport_rect().size
var ghosts: Dictionary[GhostLocation, Node2D]
var ghosts_positions: Dictionary[GhostLocation, Vector2]
var ghosts_collisions: Dictionary[GhostLocation, Array]

var object_default_collition_layer: int


func update_ghost_configuration() -> void:
	match ghosts_current_configuration:
		GhostConfiguration.UPPER_LEFT:
			ghosts_positions[GhostLocation.HORIZONTAL] = Vector2(+screen_size.x, 0)
			ghosts_positions[GhostLocation.VERTICAL] = Vector2(0, +screen_size.y)
		GhostConfiguration.UPPER_RIGHT:
			ghosts_positions[GhostLocation.HORIZONTAL] = Vector2(-screen_size.x, 0)
			ghosts_positions[GhostLocation.VERTICAL] = Vector2(0, +screen_size.y)
		GhostConfiguration.BOTTOM_LEFT:
			ghosts_positions[GhostLocation.HORIZONTAL] = Vector2(+screen_size.x, 0)
			ghosts_positions[GhostLocation.VERTICAL] = Vector2(0, -screen_size.y)
		GhostConfiguration.BOTTOM_RIGHT:
			ghosts_positions[GhostLocation.HORIZONTAL] = Vector2(-screen_size.x, 0)
			ghosts_positions[GhostLocation.VERTICAL] = Vector2(0, -screen_size.y)
	ghosts_positions[GhostLocation.DIAGONAL] = (
		ghosts_positions[GhostLocation.VERTICAL] +
		ghosts_positions[GhostLocation.HORIZONTAL]
	)


func _ready() -> void:
	update_ghost_configuration()
	for location: GhostLocation in GhostLocation.values():
		var ghost := object.duplicate()
		ghosts[location] = ghost
		add_child(ghost)
		ghost.global_position = object.global_position + ghosts_positions[location]

		# Bad bad bad
		# NOTE: checking only for TOP-level children, will not work for more nested
		# collition objects
		ghosts_collisions[location] = []
		if ghost is CollisionObject2D:
			ghosts_collisions[location].append(ghost)

		for child in ghost.get_children():
			if child is CollisionObject2D:
				ghosts_collisions[location].append(child)

		# WARNING: this assumes that all object's collision layers are the same
		object_default_collition_layer = ghost.collision_layer


func update_ghosts_collitions() -> void:
	for ghost_location: GhostLocation in GhostLocation.values():
		var ghost: Node2D = ghosts[ghost_location]
		if is_any_point_on_screen(ghost):
			send_to_default_collition(ghost_location)
		else:
			send_to_ghost_collition(ghost_location)


func send_to_ghost_collition(ghost_location: GhostLocation) -> void:
	var collision_objects := ghosts_collisions[ghost_location]
	for collision_object: CollisionObject2D in collision_objects:
		collision_object.collision_layer = (1 << GHOST_LAYER_MASK)


func send_to_default_collition(ghost_location: GhostLocation) -> void:
	var collision_objects := ghosts_collisions[ghost_location]
	for collision_object: CollisionObject2D in collision_objects:
		collision_object.collision_layer = object_default_collition_layer


func _process(_delta: float) -> void:
	update_ghosts_position()
	if is_all_points_off_screen(object):
		update_object_position()
	if should_update_ghost_configuration():
		update_ghost_configuration()
	update_ghosts_collitions()


func update_object_position() -> void:
	for location: GhostLocation in GhostLocation.values():
		if is_all_points_on_screen(ghosts[location]):
			var ghost_position := ghosts[location].global_position
			ghosts[location].global_position = object.global_position
			object.global_position = ghost_position


func update_ghosts_position() -> void:
	for ghost_loc: GhostLocation in GhostLocation.values():
		ghosts[ghost_loc].global_position = object.global_position + ghosts_positions[ghost_loc]
		ghosts[ghost_loc].rotation = object.rotation


func should_update_ghost_configuration() -> bool:
	var half_screen_x := screen_size.x / 2.
	var half_screen_y := screen_size.y / 2.
	var obj_position := object.global_position
	var new_configuration: GhostConfiguration

	if obj_position.x >= half_screen_x and obj_position.y >= half_screen_y:
		new_configuration = GhostConfiguration.BOTTOM_RIGHT
	elif obj_position.x >= half_screen_x and obj_position.y < half_screen_y:
		new_configuration = GhostConfiguration.UPPER_RIGHT
	elif obj_position.x < half_screen_x and obj_position.y >= half_screen_y:
		new_configuration = GhostConfiguration.BOTTOM_LEFT
	elif obj_position.x < half_screen_x and obj_position.y < half_screen_y:
		new_configuration = GhostConfiguration.UPPER_LEFT
	else:
		assert(false, "Something wrong in Ghost Configuration")

	if new_configuration != ghosts_current_configuration:
		ghosts_current_configuration = new_configuration
		return true
	return false


func is_all_points_off_screen(object_: Node2D) -> bool:
	return Utils.is_all_points_off_screen(object_, object_shape)


func is_all_points_on_screen(object_: Node2D) -> bool:
	return Utils.is_all_points_on_screen(object_, object_shape)


func is_any_point_on_screen(object_: Node2D) -> bool:
	return Utils.is_any_point_on_screen(object_, object_shape)
