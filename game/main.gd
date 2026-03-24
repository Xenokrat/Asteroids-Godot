extends Node

@onready var ship: Ship = $Ship


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		var attack: Attack = Attack.new()
		attack.damage = 5
		ship.get_node("HealthComponent").damage(attack)
