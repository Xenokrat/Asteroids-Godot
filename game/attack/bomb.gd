class_name Bomb
extends Node2D

const RECT_SIZE = 30

@export var max_circle_radius: float = 160.0
@export var lifetime: float = 1.5
@export var damage: int = 30
@export var knockback: int = 0

@onready var explosion_area: Area2D = $ExplosionArea

var circle_radius: float
var tween: Tween


func _ready() -> void:
	var area_shape: Shape2D = (explosion_area.get_node("CollisionShape2D") as CollisionShape2D).shape
	area_shape.radius = 0

	circle_radius = 0
	var mouse_pos := get_global_mouse_position()

	if tween != null and tween.is_valid():
		tween.kill()
	tween = create_tween()
	(tween
		.tween_property(self, "global_position", mouse_pos, lifetime)
		# .set_ease(Tween.EASE_IN_OUT)
		# .set_trans(Tween.TRANS_EXPO)
	)

	tween.set_parallel()
	(tween
		.tween_property(self, "circle_radius", max_circle_radius, .5)
		# .set_ease(Tween.EASE_IN_OUT)
		# .set_trans(Tween.TRANS_EXPO)
	)
	(tween
		.tween_property(area_shape, "radius", max_circle_radius, .5)
		# .set_ease(Tween.EASE_IN_OUT)
		# .set_trans(Tween.TRANS_EXPO)
	)
	await tween.finished
	queue_free()



func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	@warning_ignore("integer_division")
	draw_rect(Rect2(-RECT_SIZE/2, -RECT_SIZE/2, RECT_SIZE, RECT_SIZE), Color.WHITE_SMOKE, true)
	draw_circle(Vector2(0, 0), circle_radius, Color.WHITE_SMOKE, true)
	draw_circle(Vector2(0, 0), max_circle_radius, Color.WHITE_SMOKE, false)


func _on_explosion_area_area_entered(area: Area2D) -> void:
	if area is C_Hitbox:
		var attack := Attack.new()
		attack.damage = damage
		attack.knockback = knockback
		area.damage(attack)
