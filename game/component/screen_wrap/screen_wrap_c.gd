class_name ScreenWrap_C
extends Node2D

@export var root: Node2D
@export var object: Node2D
@export var object_shape: Node2D

enum GhostLocation {
	TOP,
	TOP_LEFT,
	TOP_RIGHT,
	DOWN,
	DOWN_LEFT,
	DOWN_RIGHT,
	LEFT,
	RIGHT,
}

var ghost_offsets: Dictionary[GhostLocation, Vector2]
var ghosts: Dictionary[GhostLocation, Node2D]


func _ready() -> void:
	assert(root.has_method("set_object"), "Should have method `set_object`")
	ghost_offsets = {
		GhostLocation.TOP: Vector2(0, -ScreenGlobal.screen_size.y),
		GhostLocation.TOP_LEFT: Vector2(-ScreenGlobal.screen_size.x, -ScreenGlobal.screen_size.y),
		GhostLocation.TOP_RIGHT: Vector2(+ScreenGlobal.screen_size.x, -ScreenGlobal.screen_size.y),
		GhostLocation.DOWN: Vector2(0, +ScreenGlobal.screen_size.y),
		GhostLocation.DOWN_LEFT: Vector2(-ScreenGlobal.screen_size.x, +ScreenGlobal.screen_size.y),
		GhostLocation.DOWN_RIGHT: Vector2(+ScreenGlobal.screen_size.x, +ScreenGlobal.screen_size.y),
		GhostLocation.LEFT: Vector2(-ScreenGlobal.screen_size.x, 0),
		GhostLocation.RIGHT: Vector2(+ScreenGlobal.screen_size.x, 0),
	}
	for location: GhostLocation in GhostLocation.values():
		var ghost := object.duplicate()
		ghosts[location] = ghost
		add_child(ghost)
		ghost.global_position = object.global_position + ghost_offsets[location]


func _process(_delta: float) -> void:
	if is_all_points_off_screen(object):
		for location: GhostLocation in GhostLocation.values():
			if is_all_points_on_screen(ghosts[location]):
				var ghost_to_swap: Node2D
				ghost_to_swap = ghosts[location]
				ghosts[location] = object

				root.set_object(ghost_to_swap)
				object = ghost_to_swap

	for ghost: Node2D in ghosts.values():
		ghost.rotation = object.rotation

	for ghost_loc: GhostLocation in GhostLocation.values():
		ghosts[ghost_loc].global_position = object.global_position + ghost_offsets[ghost_loc]


func is_all_points_off_screen(object_: Node2D) -> bool:
	return Utils.is_all_points_off_screen(object_, object_shape)


func is_all_points_on_screen(object_: Node2D) -> bool:
	return Utils.is_all_points_on_screen(object_, object_shape)
