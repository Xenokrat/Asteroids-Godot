class_name AsteroidOffScreenState
extends State

@export var asteroid_on_screen: AsteroidOnScreenState


func enter() -> void:
	(parent as Asteroid).off_screen_c.activate()
	(parent as Asteroid).on_screen_notifier.connect("screen_entered", _on_screen_entered)


func _on_screen_entered() -> void:
	emit_signal("state_changed", asteroid_on_screen)
