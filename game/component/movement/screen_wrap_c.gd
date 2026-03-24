class_name ScreenWrap_C
extends Node2D

@export var parent: Node2D
@export var screen_size_buffer: int = 32
@export var is_active: bool

@onready var screen_size: Vector2 = get_viewport_rect().size

var ghost: Asteroid


func _ready() -> void:
	assert(parent, "No Parent set for ScreenWrap_C")


func activate() -> void:
	is_active = true


func deactivate() -> void:
	is_active = false


func _physics_process(_delta: float) -> void:
	if not is_active:
		return
	# if true:
	parent.global_position.x = wrapf(parent.global_position.x, 0 - screen_size_buffer, screen_size.x + screen_size_buffer)
	parent.global_position.y = wrapf(parent.global_position.y, 0 - screen_size_buffer, screen_size.y + screen_size_buffer)


func wrapAAA() -> void:
	if Utils.is_node_on_screen_edge(parent, parent.polygon.polygon):
		if not ghost:
			print("ADDING GHOST")
			var parent_ghost := parent.duplicate()
			add_child(parent_ghost)
			ghost = parent_ghost
			# var x: float = min(parent.global_position.x, screen_size.x - parent.global_position.x)
			# var y: float = min(parent.global_position.y, screen_size.y - parent.global_position.y)
			ghost.global_position = Vector2(absf(screen_size.x - parent.global_position.x), 200)

# func _min_distance_to_x_edge(node: Node2D) -> float:
# 	var distance: float
# 	if node.global_position.x < 0:
# 		distance = -node.global_position.x
# 	elif node.global_position.x > screen_size.x:
# 		distance = node.global_position.x - screen_size.x
# 	else:
# 		distance = min()
