extends Node2D

@export var spawner: Spawner
@export var cell_side_length: float
@export var object: Node2D


func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	queue_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		get_teleport_tiles()


func get_astegoids_on_screen() -> Dictionary[Vector2i, int]:
	assert(spawner, "No spawner is set!")
	assert(cell_side_length > 0, "Size of the grid square should be more than 0")

	var asteroids_points: Array = spawner.get_astegoids_on_screen().map(asteroid_to_global_points)

	var occupied_tiles: Dictionary[Vector2i, int]
	for points: PackedVector2Array in asteroids_points:
		for point: Vector2 in points:
			var mapped_point: Vector2i = Vector2i(
				int(point.x / cell_side_length),
				int(point.y / cell_side_length),
			)
			occupied_tiles[mapped_point] = true
	return occupied_tiles


func get_teleport_tiles() -> void:
	var points := get_astegoids_on_screen()
	var screen_size := get_viewport_rect().size
	var squares: Dictionary[Vector2i, int] = { }
	var cols := int(screen_size.y / cell_side_length)
	var rows := int(screen_size.x / cell_side_length)
	for row in range(rows):
		for col in range(cols + 1):
			squares[Vector2i(row, col)] = 0
	points.merge(squares, false)

	var non_occupied_tiles: Array = []
	# position | distance from player | neighbours count
	#    0^              1^                 2^
	var object_posi := Vector2i(
		object.global_position.x / cell_side_length as int,
		object.global_position.y / cell_side_length as int,
	)
	for position_vec: Vector2i in points.keys():
		if points[position_vec] == 0:
			non_occupied_tiles.append([position_vec, object_posi.distance_to(position_vec)])

	non_occupied_tiles.sort_custom(func(a: Array, b: Array) -> bool: return a[1] > b[1]) # DESC
	# 1. select top 10 most distant tiles
	non_occupied_tiles = non_occupied_tiles.slice(0, 10)
	# 2. do the heatmap
	for tile: Array in non_occupied_tiles:
		var position_vec: Vector2i = tile[0]
		tile.append(0)
		for i in range(-1, 1, 1):
			for j in range(-1, 1, 1):
				if i == 0 and j == 0:
					continue
				var position_vec_neighbour := position_vec + Vector2i(i, j)
				if points.has(position_vec_neighbour) and points[position_vec_neighbour] != 0:
					tile[2] += 1
	# 2. sort by heatmap
	non_occupied_tiles.sort_custom(func(a: Array, b: Array) -> bool: return a[2] < b[2]) # ASC
	# 3. select top 3
	non_occupied_tiles = non_occupied_tiles.slice(0, 3)
	# 4. pick random
	object.global_position = non_occupied_tiles.pick_random()[0] * cell_side_length \
	+ Vector2(cell_side_length / 2, cell_side_length / 2)


func _draw() -> void:
	if Debug.DRAW_TELEPORT_LAYER:
		debug_draw()


func debug_draw() -> void:
	var points := get_astegoids_on_screen()
	var screen_size := get_viewport_rect().size
	var squares: Dictionary[Vector2i, int] = { }
	var cols := int(screen_size.y / cell_side_length)
	var rows := int(screen_size.x / cell_side_length)
	for row in range(rows):
		for col in range(cols + 1):
			squares[Vector2i(row, col)] = 0
	points.merge(squares, false)

	var non_occupied_tiles: Array = []
	var object_posi := Vector2i(
		object.global_position.x / cell_side_length as int,
		object.global_position.y / cell_side_length as int,
	)
	for position_vec: Vector2i in points.keys():
		if points[position_vec] == 0:
			non_occupied_tiles.append([position_vec, object_posi.distance_to(position_vec)])
			draw_rect(Rect2(position_vec.x * cell_side_length, position_vec.y * cell_side_length, cell_side_length, cell_side_length), Color(1, 1, 1, 0.1), true)
		else:
			draw_rect(Rect2(position_vec.x * cell_side_length, position_vec.y * cell_side_length, cell_side_length, cell_side_length), Color(1, 1, 1, 0.5), true)

	non_occupied_tiles.sort_custom(func(a: Array, b: Array) -> bool: return a[1] > b[1]) # DESC
	# 1. select top 10 most distant tiles
	non_occupied_tiles = non_occupied_tiles.slice(0, 10)
	# 2. do the heatmap
	for tile: Array in non_occupied_tiles:
		var position_vec: Vector2i = tile[0]
		tile.append(0)
		for i in range(-1, 1, 1):
			for j in range(-1, 1, 1):
				if i == 0 and j == 0:
					continue
				var position_vec_neighbour := position_vec + Vector2i(i, j)
				if points.has(position_vec_neighbour) and points[position_vec_neighbour] != 0:
					tile[2] += 1
	# 2. sort by heatmap
	non_occupied_tiles.sort_custom(func(a: Array, b: Array) -> bool: return a[2] < b[2]) # ASC
	# 3. select top 3
	non_occupied_tiles = non_occupied_tiles.slice(0, 3)


	for tile: Array in non_occupied_tiles:
		draw_rect(
			Rect2(tile[0].x * cell_side_length, tile[0].y * cell_side_length, cell_side_length, cell_side_length),
			Color(0.2, 0.2, 1, 1),
			true,
		)
		draw_line(object.global_position, Vector2(tile[0].x * cell_side_length, tile[0].y * cell_side_length), Color.RED)


func asteroid_to_global_points(x: Asteroid) -> Array[Vector2]:
	var res: Array[Vector2] = []
	var points := Utils.node_to_vec2_array(x.polygon)
	for p in points:
		res.append(x.to_global(p))
	return res
