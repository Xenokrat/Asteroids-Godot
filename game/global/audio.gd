extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer


func _ready() -> void:
	music_player.playing = true
