class_name Bonus
extends Node2D


signal bonus_picked(type: BonusType)

enum BonusType {
	TRIPLE_SHOT,
	BOMB,
	SHIELD,
}

@onready var area : Area2D = $Area2D

var triple_shot_icon : Texture2D = preload("res://assets/visual/triple-shot.svg")
var bomb_icon : Texture2D = preload("res://assets/visual/bomb-bonus.svg")
var shield_icon : Texture2D = preload("res://assets/visual/shield-bonus.svg")

var bonus_type: BonusType


func _ready() -> void:
	bonus_type = BonusType.values().pick_random()
	var sprite := Sprite2D.new()
	match bonus_type:
		BonusType.TRIPLE_SHOT:
			sprite.texture = triple_shot_icon
		BonusType.BOMB:
			sprite.texture = bomb_icon
		BonusType.SHIELD:
			sprite.texture = shield_icon
	sprite.scale = Vector2(1.5, 1.5)
	add_child(sprite)

	area.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "ShipPlayer":
		bonus_picked.emit(bonus_type)
		queue_free()
