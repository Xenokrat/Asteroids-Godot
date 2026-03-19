class_name HealthUI
extends Node2D

@export var health_c: HealthComponent

var health_bar: ProgressBar = null


func _ready() -> void:
	health_c.connect("health_changed", _on_health_changed)
	for child in get_children():
		if child is ProgressBar:
			health_bar = child
			break
	if not health_bar:
		assert(false, "Forgor to set a health bar!")
	health_bar.show_percentage = false
	health_bar.visible = false
	health_bar.value = 100


func _process(_delta: float) -> void:
	global_rotation = 0


func _on_health_changed(new_health: int) -> void:
	var max_health := health_c.MAX_HEALTH
	if new_health == max_health:
		health_bar.visible = false
		return
	health_bar.visible = true
	health_bar.value = new_health / float(max_health) * 100


func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	if not health_bar:
		warnings.append("Heath Bar (ProgressBar Node) is not set!")
	return warnings
