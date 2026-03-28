class_name Asteroid
extends RigidBody2D

enum AsteroidType {
	SMALL,
	MID,
	BIG,
}

const ANGULAR_VELOCITY_VARIATION = PI / 2

@export var speed: int = 0
@export var asteroid_type: AsteroidType

@onready var hitbox_c: HitboxComponent = %HitboxComponent
@onready var polygon: Polygon2D = %Polygon2D
@onready var state_machine: StateMachine = %StateMachine
@onready var off_screen_c: OffScreen_C = %OffScreen_C

var spawner: Spawner


func _ready() -> void:
	var collision_polygon: CollisionPolygon2D = CollisionPolygon2D.new()
	collision_polygon.polygon = polygon.polygon
	hitbox_c.call_deferred("add_child", collision_polygon)

	var collision_polygon2 := collision_polygon.duplicate()
	call_deferred("add_child", collision_polygon2)

	state_machine.init(self)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)


func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)


func set_speed() -> void:
	add_constant_central_force(Vector2.RIGHT.rotated(rotation) * speed)


func set_rotation_movement() -> void:
	angular_velocity = randf_range(-ANGULAR_VELOCITY_VARIATION, ANGULAR_VELOCITY_VARIATION)


func set_initial_position(global_pos: Vector2) -> void:
	global_position = global_pos


func set_initial_rotation(angle: float) -> void:
	rotation = angle


func destroy() -> void:
	match asteroid_type:
		AsteroidType.SMALL:
			pass
		AsteroidType.MID:
			if spawner:
				spawner.spawn_small_asteroids(2, global_position)
		AsteroidType.BIG:
			if spawner:
				spawner.spawn_small_asteroids(4, global_position)
	queue_free()
