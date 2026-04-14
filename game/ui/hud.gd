class_name Hud
extends Control

var score_label: RichTextLabel
var triple_bonus_icon: TextureRect
var triple_bonus_progress_bar: ProgressBar

var triple_bonus_lifetime: float
var triple_bonus_max_lifetime: float

var tween: Tween


func _ready() -> void:
	score_label = %ScoreLabel
	triple_bonus_icon = %TripleBonusTexture
	triple_bonus_progress_bar = %TripleBonusProgressBar
	PlayerResources.score_changed.connect(_on_score_changed)


func _on_score_changed() -> void:
	score_label.text = "[b]" + str(PlayerResources.score)


func _on_triple_bonus_picked(time: float) -> void:
	triple_bonus_icon.visible = true
	triple_bonus_progress_bar.visible = true
	triple_bonus_progress_bar.value = 100.0

	if tween != null and tween.is_valid():
		tween.kill()
	tween = create_tween()
	await tween.tween_property(triple_bonus_progress_bar, "value", 0, time).finished

	triple_bonus_icon.visible = false
	triple_bonus_progress_bar.visible = false
