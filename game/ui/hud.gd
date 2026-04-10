extends Node2D

@onready var bomb_ui: VBoxContainer = $BombHContainer
var bomb_texture: Texture2D = load("res://icon.svg")


func _ready() -> void:
	for b in range(PlayerResources.bombs):
		var bomb_texture_rect := TextureRect.new()
		bomb_texture_rect.texture = bomb_texture
		bomb_ui.add_child(bomb_texture_rect)

	PlayerResources.bombs_count_changed.connect(_on_bombs_count_changed)


func _on_bombs_count_changed() -> void:
	for b in bomb_ui.get_children():
		b.queue_free()

	for b in range(PlayerResources.bombs):
		var bomb_texture_rect := TextureRect.new()
		bomb_texture_rect.texture = bomb_texture
		bomb_ui.add_child(bomb_texture_rect)
