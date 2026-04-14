class_name Spawner
extends Node2D

@warning_ignore("unused_signal")
signal asteroid_destroyed(type: Asteroid.AsteroidType, global_position: Vector2)

@warning_ignore("unused_signal")
signal saucer_destroyed(global_position: Vector2)

enum {
	DANGER_LEVEL1 = 0,
	DANGER_LEVEL2,
	DANGER_LEVEL3,
}
const ASTEROID_START_ANGLE_VARIATION := PI / 8
const START_ASTEROID_COUNT := 5

const ASTEROID_SPAWN_PROBABILITIES: Array[PackedFloat32Array] = [
	[
		0.5, # small
		0.3, # mid
		0.2, # big
	],
	[
		0.4, # small
		0.4, # mid
		0.2, # big
	],
	[
		0.3, # small
		0.4, # mid
		0.3, # big
	],
]

const MINIMAL_SPAWN_WAIT_TIME := 0.5

@export var asteroids_scenes: Array[PackedScene]
@export var small_asteroid_scene: PackedScene
@export var saucer_scene: PackedScene
@export var player: Ship

@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawn_path: PathFollow2D = %PathFollow2D
@onready var rng := RandomNumberGenerator.new()
@onready var saucer_timer: Timer = $SaucerTimer

var asteroids: Array[Asteroid]
var spawn_probabilities: PackedFloat32Array
var spawn_markers: Dictionary[Marker2D, Vector2]

# DEBUG
@export var turn_off: bool = false


func _ready() -> void:
	for i in range(START_ASTEROID_COUNT):
		spawn_asteroid()
	spawn_probabilities = ASTEROID_SPAWN_PROBABILITIES[DANGER_LEVEL1]
	spawn_markers = {
		$Marker2D1: Vector2(0, 1),
		$Marker2D2: Vector2(0, 1),
		$Marker2D3: Vector2(1, 0),
		$Marker2D4: Vector2(-1, 0),
	}

	# Signals
	saucer_timer.timeout.connect(_on_saucer_timer_timeout)


func spawn_asteroid() -> void:
	if turn_off:
		return

	var asteroid: Node2D = asteroids_scenes[rng.rand_weighted(ASTEROID_SPAWN_PROBABILITIES)].instantiate()
	assert(asteroid.has_method("set_initial_position"), "No `set_initial_position` method in spawner")
	assert(asteroid.has_method("set_initial_rotation"), "No `set_initial_rotation` method in spawner")
	assert(asteroid.has_method("set_speed"), "No `set_speed` method in spawner")

	asteroid.spawner = self
	add_child(asteroid)

	asteroid.set_initial_position(spawn_path.global_position)
	asteroid.set_initial_rotation(
		spawn_path.rotation
		+ PI / 2
		+ randf_range(-ASTEROID_START_ANGLE_VARIATION, ASTEROID_START_ANGLE_VARIATION),
	)
	asteroid.set_speed()
	spawn_path.progress_ratio += randf_range(.1, .3)
	asteroid.asteroid_destroyed.connect(_on_asteroid_destroyed)


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
		angle += PI / asteroids_count


func get_astegoids_on_screen() -> Array[Asteroid]:
	var res: Array[Asteroid]
	for asteroid in asteroids:
		if asteroid.state_machine.current_state is AsteroidOnScreenState:
			res.append(asteroid)
	return res


func remove_asteroid(asteroid: Asteroid) -> void:
	asteroids.remove_at(asteroids.find(asteroid))


func add_astegoid(asteroid: Asteroid) -> void:
	asteroids.append(asteroid)


# Timeout callbacks
func _on_spawn_timer_timeout() -> void:
	spawn_asteroid()


func _on_danger_timer_timeout() -> void:
	spawn_timer.wait_time = max(
		spawn_timer.wait_time - 0.1,
		MINIMAL_SPAWN_WAIT_TIME,
	)
	if spawn_timer.wait_time < 2.0:
		spawn_probabilities = ASTEROID_SPAWN_PROBABILITIES[DANGER_LEVEL2]

	if spawn_timer.wait_time < 1.0:
		spawn_probabilities = ASTEROID_SPAWN_PROBABILITIES[DANGER_LEVEL3]


func _on_saucer_timer_timeout() -> void:
	var saucer: Saucer = saucer_scene.instantiate()
	var spawn_marker: Marker2D = spawn_markers.keys().pick_random()
	var velocity: Vector2 = spawn_markers[spawn_marker]
	saucer.set_velocity(velocity)
	add_child(saucer)
	saucer.global_position = spawn_marker.global_position
	saucer.player = player
	saucer.shooter_c.projectile_space = self


func _on_asteroid_destroyed(type: Asteroid.AsteroidType, global_position_: Vector2) -> void:
	asteroid_destroyed.emit(type, global_position_)


func _on_saucer_destroyed(global_position_: Vector2) -> void:
	# TODO
	saucer_destroyed.emit(global_position_)
