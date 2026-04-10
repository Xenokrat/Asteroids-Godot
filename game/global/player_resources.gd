extends Node

@warning_ignore("unused_signal")
signal bombs_count_changed

const MAX_BOMBS := 2
var bombs: int


func _ready() -> void:
	reset()


func reset() -> void:
	bombs = MAX_BOMBS


func use_bomb() -> bool:
	if bombs > 0:
		bombs -= 1
		emit_signal("bombs_count_changed")
		return true
	return false
