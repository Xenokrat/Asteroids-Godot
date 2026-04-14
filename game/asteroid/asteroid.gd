class_name Asteroid
extends RigidBody2D

@warning_ignore("unused_signal")
signal asteroid_destroyed(type: AsteroidType, global_position: Vector2)

enum AsteroidType {
	SMALL,
	MID,
	BIG,
}

@export var speed: int = 0
@export var asteroid_type: AsteroidType

@onready var hitbox_c: C_Hitbox = %C_Hitbox
@onready var polygon: Polygon2D = %Polygon2D
@onready var state_machine: StateMachine = %StateMachine
@onready var off_screen_c: OffScreen_C = %OffScreen_C

@export var spawner: Spawner


func _ready() -> void:
	var collision_polygon: CollisionPolygon2D = CollisionPolygon2D.new()
	collision_polygon.polygon = polygon.polygon
	hitbox_c.call_deferred("add_child", collision_polygon)

	var collision_polygon2 := collision_polygon.duplicate()
	call_deferred("add_child", collision_polygon2)

	state_machine.init(self)
	if spawner:
		spawner.add_astegoid(self)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)


func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)


func set_speed() -> void:
	add_constant_central_force(Vector2.RIGHT.rotated(rotation) * speed)


func set_initial_position(global_pos: Vector2) -> void:
	global_position = global_pos


func set_initial_rotation(angle: float) -> void:
	rotation = angle


func set_collition_to_ghost() -> void:
	print("Called `set_collition_to_ghost`")


func destroy() -> void:
	match asteroid_type:
		AsteroidType.SMALL:
			PlayerResources.update_score(PlayerResources.SCORE_SMALL_ASTEROID)
		AsteroidType.MID:
			if spawner:
				spawner.spawn_small_asteroids(2, global_position)
			PlayerResources.update_score(PlayerResources.SCORE_MID_ASTEROID)
		AsteroidType.BIG:
			if spawner:
				spawner.spawn_small_asteroids(4, global_position)
			PlayerResources.update_score(PlayerResources.SCORE_BIG_ASTEROID)
	spawner.remove_asteroid(self)
	asteroid_destroyed.emit(asteroid_type, global_position)
	queue_free()
