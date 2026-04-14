class_name Shooter_C
extends Node2D

enum ShooterState {
	SINGLE,
	TRIPLET,
}

@export var projectile_space: Node2D
@export var shooting_point: Marker2D
@export var bullet_scene: PackedScene
@export var bomb_scene: PackedScene

@onready var state: ShooterState = ShooterState.SINGLE


func shoot() -> void:
	match state:
		ShooterState.SINGLE:
			_shoot()
		ShooterState.TRIPLET:
			_shoot_triplet()


func to_shoot_single() -> void:
	state = ShooterState.SINGLE


func to_shoot_triplet() -> void:
	state = ShooterState.TRIPLET


func _shoot() -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	projectile_space.add_child(bullet)
	bullet.global_position = shooting_point.global_position
	bullet.global_rotation = shooting_point.global_rotation


func _shoot_triplet() -> void:
	var bullets: Array[Bullet] = []
	for b in range(3):
		var bullet: Bullet = bullet_scene.instantiate()
		bullets.append(bullet)
		projectile_space.add_child(bullet)
		bullet.global_position = shooting_point.global_position

	bullets[0].global_rotation = shooting_point.global_rotation
	bullets[1].global_rotation = shooting_point.global_rotation - PI / 4
	bullets[2].global_rotation = shooting_point.global_rotation + PI / 4


func shoot_bomb() -> void:
	var bomb: Bomb = bomb_scene.instantiate()
	projectile_space.add_child(bomb)
	bomb.global_position = shooting_point.global_position
	bomb.global_rotation = shooting_point.global_rotation
