class_name OffScreen_C
extends Node2D

const ROTATE_UPPER_LEFT := 3. / 4. * PI
const ROTATE_UPPER := PI
const ROTATE_UPPER_RIGHT := 5. / 4. * PI
const ROTATE_RIGHT := 3. / 2. * PI
const ROTATE_BOTTOM_RIGHT := 7. / 4. * PI
const ROTATE_BOTTOM := 0
const ROTATE_BOTTOM_LEFT := 1. / 4. * PI
const ROTATE_LEFT := 1. / 2. * PI
const EDGE_OFFSET := 20

@export var is_active: bool
@export var parent: Node2D
@export var indicator: Node2D

@onready var screen_size: Vector2 = get_viewport_rect().size


func _ready() -> void:
	assert(parent, "Parent is not set for OffScreen_C!")


func deactivate() -> void:
	is_active = false
	indicator.visible = false


func activate() -> void:
	is_active = true
	indicator.visible = true


func _process(_delta: float) -> void:
	if not is_active:
		return

	var parent_pos: Vector2 = parent.global_position

	#   1 |      2      | 3
	# --- +-------------+ ---
	#     |             |
	#   8 |   screen    | 4
	#     |             |
	# --- +-------------+ ---
	#   7 |      6      | 5
	# 1
	if (parent_pos.x < 0 and
		parent_pos.y < 0 ):
		global_position = Vector2(0 + EDGE_OFFSET, 0 + EDGE_OFFSET)
		global_rotation = ROTATE_UPPER_LEFT
	# 2
	elif (parent_pos.x >= 0 and
		parent_pos.x < screen_size.x and
		parent_pos.y < 0 ):
		global_position = Vector2(parent_pos.x, 0 + EDGE_OFFSET)
		global_rotation = ROTATE_UPPER
	# 3
	elif (parent_pos.x >= screen_size.x and
		parent_pos.y < 0 ):
		global_position = Vector2(screen_size.x - EDGE_OFFSET, 0 + EDGE_OFFSET)
		global_rotation = ROTATE_UPPER_RIGHT
	# 4
	elif (parent_pos.x >= screen_size.x and
		parent_pos.y >= 0 and
		parent_pos.y < screen_size.y ):
		global_position = Vector2(screen_size.x - EDGE_OFFSET, parent_pos.y)
		global_rotation = ROTATE_RIGHT
	# 5
	elif (parent_pos.x >= screen_size.x and
		parent_pos.y >= screen_size.y ):
		global_position = Vector2(screen_size.x - EDGE_OFFSET, screen_size.y - EDGE_OFFSET)
		global_rotation = ROTATE_BOTTOM_RIGHT
	# 6
	elif (parent_pos.x >= 0 and
		parent_pos.x < screen_size.x and
		parent_pos.y >= screen_size.y ):
		global_position = Vector2(parent_pos.x, screen_size.y - EDGE_OFFSET)
		global_rotation = ROTATE_BOTTOM
	# 7
	elif (parent_pos.x < screen_size.x and
		parent_pos.y >= screen_size.y ):
		global_position = Vector2(0 + EDGE_OFFSET, screen_size.y - EDGE_OFFSET)
		global_rotation = ROTATE_BOTTOM_LEFT
	# 8
	elif (parent_pos.x < 0 and
		parent_pos.y >= 0 and
		parent_pos.y < screen_size.y ):
		global_position = Vector2(0 + EDGE_OFFSET, parent_pos.y)
		global_rotation = ROTATE_LEFT

	else:
		# assert(false, "Indicator is on screen, which is wrong!")
		pass
