class_name Saucer
extends Node2D

enum SaucerState {
	MOVING,
	SHOOTING,
}

const SHOOT_ANGLE_VARIANCE := PI / 12

@export var player: Ship
@export var speed: int = 400

@onready var off_screen_c: OffScreen_C = $OffScreen_C
@onready var shooter_c: Shooter_C = $Shooter_C
@onready var bullet_marker: Marker2D = %BulletMarker
@onready var attack_timer: Timer = $AttackTimer
@onready var moving_timer: Timer = $MovingTimer

var velocity: Vector2
var state: SaucerState


func _ready() -> void:
	off_screen_c.activate()
	state = SaucerState.MOVING

	# signal
	moving_timer.timeout.connect(_on_moving_timer_timeout)
	moving_timer.start()


func _process(delta: float) -> void:
	match state:
		SaucerState.MOVING:
			global_position += velocity.normalized() * speed * delta
		SaucerState.SHOOTING:
			pass


func destroy() -> void:
	PlayerResources.update_score(PlayerResources.SCORE_SAUCER_ASTEROID)
	queue_free()


func turn_to_player() -> void:
	bullet_marker.look_at(player.ship.global_position)
	bullet_marker.rotation += randf_range(-SHOOT_ANGLE_VARIANCE, +SHOOT_ANGLE_VARIANCE) + PI / 2


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	off_screen_c.deactivate()


func _on_timer_timeout() -> void:
	turn_to_player()
	shooter_c.shoot()


func set_velocity(velocity_: Vector2) -> void:
	velocity = velocity_


func _on_moving_timer_timeout() -> void:
	attack_timer.start()
	state = SaucerState.SHOOTING
