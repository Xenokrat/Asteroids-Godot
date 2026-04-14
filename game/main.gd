extends Node


@onready var hud: Hud = $Hud
@onready var bonus_manager: BonusManager = $BonusManager


func _ready() -> void:
	bonus_manager.triple_bonus_picked.connect(hud._on_triple_bonus_picked)
