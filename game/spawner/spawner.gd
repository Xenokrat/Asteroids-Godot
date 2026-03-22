class_name Spawner
extends Node2D

const ASTEROID_START_ANGLE_VARIATION := PI / 4
const START_ASTEROID_COUNT := 5

@export var asteroids_scenes: Array[PackedScene]
@export var small_asteroid_scene: PackedScene

@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawn_path: PathFollow2D = %PathFollow2D

# DEBUG
@export var turn_off: bool = false


func _ready() -> void:
	for i in range(START_ASTEROID_COUNT):
		spawn_asteroid()


func _on_spawn_timer_timeout() -> void:
	spawn_asteroid()


func spawn_asteroid() -> void:
	if turn_off:
		return
	var asteroid: Asteroid = asteroids_scenes.pick_random().instantiate()
	asteroid.spawner = self
	add_child(asteroid)

	asteroid.set_initial_position(spawn_path.global_position)
	asteroid.set_initial_rotation(
		spawn_path.rotation
		+ PI / 2
		+ randf_range(-ASTEROID_START_ANGLE_VARIATION, ASTEROID_START_ANGLE_VARIATION),
	)
	asteroid.set_speed()
	asteroid.set_rotation_movement()

	spawn_path.progress_ratio += randf_range(.1, .3)


func spawn_small_asteroids(asteroids_count: int, global_pos: Vector2) -> void:
	var asteroid: Asteroid
	var angle := randf_range(-PI, PI)
	for _i in range(asteroids_count):
		asteroid = small_asteroid_scene.instantiate()
		asteroid.spawner = self
		add_child(asteroid)
		asteroid.set_initial_position(global_pos)
		asteroid.set_initial_rotation(angle + randf_range(-ASTEROID_START_ANGLE_VARIATION, ASTEROID_START_ANGLE_VARIATION))
		asteroid.set_speed()
		asteroid.set_rotation_movement()
		angle += PI / asteroids_count
