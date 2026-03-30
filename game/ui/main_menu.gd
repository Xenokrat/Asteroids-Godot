class_name MainMenu
extends Control

func _ready() -> void:
	for child in get_children():
		if child is Asteroid:
			(child as Asteroid).set_initial_rotation(randf() * PI)


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://game/main.tscn")


func _on_options_button_pressed() -> void:
	assert(false, "TODO: options menu")
	get_tree().change_scene_to_file("res://game/option.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
