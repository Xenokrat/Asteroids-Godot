extends Node2D

@export var spawner: Spawner
@export var cell_side_length: float

var grid: Array = []


func _ready() -> void:
	for i in range(8):
		var row: Array[int] = []
		for j in range(8):
			row.append(0)
		grid.append(row)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		print(get_astegoids_on_screen())


func get_astegoids_on_screen() -> Dictionary[Vector2i, int]:
	assert(spawner, "No spawner is set!")
	assert(cell_side_length > 0, "Size of the grid square should be more than 0")

	var asteroids_points: Array = (
		spawner.get_astegoids_on_screen() \
		.map(
			func(x: Asteroid) -> PackedVector2Array: return Utils.node_to_vec2_array(x.polygon)
		)
	)

	var occupied_tiles: Dictionary[Vector2i, int]
	for points: PackedVector2Array in asteroids_points:
		for point: Vector2 in points:
			var mapped_point: Vector2i = Vector2i(
				int(point.x / cell_side_length),
				int(point.y / cell_side_length),
			)
			occupied_tiles[mapped_point] = true
	print(occupied_tiles)
	return occupied_tiles
