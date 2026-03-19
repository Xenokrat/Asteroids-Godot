class_name HealthComponent
extends Node

signal health_changed(new_health: int)

@export var MAX_HEALTH := 10
var health: int


func _ready() -> void:
	health = MAX_HEALTH


func damage(attack: Attack) -> void:
	health -= attack.damage
	emit_signal("health_changed", health)
	if health <= 0:
		var parent: Node2D = get_parent()
		assert(parent.has_method("destroy"), "No `destroy` method for killed object!")
		parent.destroy()
