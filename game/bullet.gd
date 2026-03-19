class_name Bullet
extends Node2D

@export var speed := 800
@export var damage := 5


func _process(delta: float) -> void:
	var velocity := Vector2.UP.rotated(rotation) * speed
	position += velocity * delta


func _on_timer_timeout() -> void:
	queue_free()


func _on_hitbox_area_2d_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var attack: = Attack.new()
		attack.damage = damage
		area.damage(attack)
		queue_free()
