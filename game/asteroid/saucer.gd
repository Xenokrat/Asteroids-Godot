extends Node2D

const SHOOT_ANGLE_VARIANCE := PI / 12

@export var player: Ship

@onready var off_screen_c: OffScreen_C = $OffScreen_C
@onready var shooter_c: Shooter_C = $Shooter_C
@onready var bullet_marker: Marker2D = %BulletMarker


func _ready() -> void:
	off_screen_c.activate()


func destroy() -> void:
	queue_free()


func turn_to_player() -> void:
	bullet_marker.look_at(player.ship.global_position)
	bullet_marker.rotation += randf_range(-SHOOT_ANGLE_VARIANCE, +SHOOT_ANGLE_VARIANCE) + PI / 2


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	off_screen_c.deactivate()


func _on_timer_timeout() -> void:
	turn_to_player()
	shooter_c.shoot()
