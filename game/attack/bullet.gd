class_name Bullet
extends Node2D

@export var speed := 800
@export var damage := 5

@onready var hitbox: Area2D = $HitboxArea2D


func _process(delta: float) -> void:
	var velocity := Vector2.UP.rotated(rotation) * speed
	position += velocity * delta
	queue_redraw()


func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0, Vector2(1, 2))
	draw_circle(Vector2(0, 0), 4, Color.WHITE, true, -1, true)


func _on_timer_timeout() -> void:
	queue_free()


func _on_hitbox_area_2d_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		var attack: = Attack.new()
		attack.damage = damage
		area.damage(attack)
		queue_free()
