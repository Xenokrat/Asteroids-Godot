class_name BonusManager
extends Node

@warning_ignore("unused_signal")
signal triple_bonus_picked(time: float)

@warning_ignore("unused_signal")
signal shield_bonus_picked(time: float)

const BONUS_SPAWN_PROBABILITY = 0.5

@export var spawner: Spawner
@export var player: Ship
@export var bonus_scene: PackedScene

@onready var triple_shoot_timer: Timer = $TripleShootTimer
@onready var shield_timer: Timer = $ShieldTimer


func _ready() -> void:
	spawner.asteroid_destroyed.connect(_on_asteroid_destroyed)
	triple_shoot_timer.timeout.connect(_on_triple_shoot_timer_timeout)
	shield_timer.timeout.connect(_on_shield_timer_timeout)


func _on_asteroid_destroyed(_type: Asteroid.AsteroidType, global_pos: Vector2) -> void:
	if randf() >= BONUS_SPAWN_PROBABILITY:
		return
	var bonus: Bonus = bonus_scene.instantiate()
	bonus.global_position = global_pos
	bonus.bonus_picked.connect(_on_bonus_picked)
	call_deferred("add_child", bonus)


func _on_bonus_picked(type: Bonus.BonusType) -> void:
	match type:
		Bonus.BonusType.BOMB:
			PlayerResources.bombs += 1
		Bonus.BonusType.TRIPLE_SHOT:
			triple_shoot_timer.start()
			player.shooter_c.to_shoot_triplet()
			triple_bonus_picked.emit(triple_shoot_timer.wait_time)
		Bonus.BonusType.SHIELD:
			player.activate_shield()
			shield_bonus_picked.emit(shield_timer.wait_time)


func _on_triple_shoot_timer_timeout() -> void:
	player.shooter_c.to_shoot_single()


func _on_shield_timer_timeout() -> void:
	player.deactivate_shield()
