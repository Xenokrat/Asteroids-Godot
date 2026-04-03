class_name Spawner
extends Node2D

const ASTEROID_START_ANGLE_VARIATION := PI / 8
const START_ASTEROID_COUNT := 5
const ASTEROID_TYPE_SPAWN_PROBABILITY: PackedFloat32Array = [
	0.5, # small
	0.3, # mid
	0.2, # big
]
const MINIMAL_SPAWN_WAIT_TIME := 0.5

@export var asteroids_scenes: Array[PackedScene]
@export var small_asteroid_scene: PackedScene

@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawn_path: PathFollow2D = %PathFollow2D

@onready var rng := RandomNumberGenerator.new()

var asteroids: Array[Asteroid]

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

	var enemy: Node2D = asteroids_scenes[rng.rand_weighted(ASTEROID_TYPE_SPAWN_PROBABILITY)].instantiate()
	assert(enemy.has_method("set_initial_position"), "No `set_initial_position` method in spawner")
	assert(enemy.has_method("set_initial_rotation"), "No `set_initial_rotation` method in spawner")
	assert(enemy.has_method("set_speed"), "No `set_speed` method in spawner")

	enemy.spawner = self
	add_child(enemy)
	asteroids.append(enemy)

	enemy.set_initial_position(spawn_path.global_position)
	enemy.set_initial_rotation(
		spawn_path.rotation
		+ PI / 2
		+ randf_range(-ASTEROID_START_ANGLE_VARIATION, ASTEROID_START_ANGLE_VARIATION),
	)
	enemy.set_speed()
	spawn_path.progress_ratio += randf_range(.1, .3)


func spawn_small_asteroids(asteroids_count: int, global_pos: Vector2) -> void:
	var asteroid: Asteroid
	var angle := randf_range(-PI, PI)
	for _i in range(asteroids_count):
		asteroid = small_asteroid_scene.instantiate()
		asteroid.spawner = self
		add_child(asteroid)
		asteroids.append(asteroid)
		asteroid.set_initial_position(global_pos)
		asteroid.set_initial_rotation(angle + randf_range(-ASTEROID_START_ANGLE_VARIATION, ASTEROID_START_ANGLE_VARIATION))
		asteroid.set_speed()
		angle += PI / asteroids_count


func get_astegoids_on_screen() -> Array[Asteroid]:
	var res: Array[Asteroid]
	for asteroid in asteroids:
		if asteroid.state_machine.current_state is AsteroidOnScreenState:
			res.append(asteroid)
	return res


func _on_danger_timer_timeout() -> void:
	spawn_timer.wait_time = max(
		spawn_timer.wait_time - 0.2,
		MINIMAL_SPAWN_WAIT_TIME
	)
