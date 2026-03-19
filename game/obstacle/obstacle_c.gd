class_name ObstacleC
extends Node

@export var hitbox_c: HitboxComponent


func _ready() -> void:
	hitbox_c.connect("body_entered", _on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is Ship:
		var attack := Attack.new()
		attack.damage = 10
		attack.knokback = 3
		body.damage(attack)
