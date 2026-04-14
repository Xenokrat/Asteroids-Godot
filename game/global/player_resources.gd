extends Node

@warning_ignore("unused_signal")
signal bombs_count_changed

@warning_ignore("unused_signal")
signal score_changed

const MAX_BOMBS := 3
const SCORE_SMALL_ASTEROID = 1
const SCORE_MID_ASTEROID = 3
const SCORE_BIG_ASTEROID = 10
const SCORE_SAUCER_ASTEROID = 30

var bombs: int:
	set(value):
		bombs = min(value, MAX_BOMBS)
	get:
		return bombs

var score: int


func _ready() -> void:
	reset()


func reset() -> void:
	bombs = MAX_BOMBS - 1
	print("bombs: ", bombs)
	score = 0


func use_bomb() -> bool:
	if bombs > 0:
		bombs -= 1
		emit_signal("bombs_count_changed")
		return true
	return false


func update_score(value: int) -> void:
	score += value
	emit_signal("score_changed")
