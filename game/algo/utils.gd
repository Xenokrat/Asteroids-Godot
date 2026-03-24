class_name Utils
extends Node

static func is_any_point_on_screen(node: Node2D, points: PackedVector2Array) -> bool:
	var screen_size := node.get_viewport_rect().size
	for p in points:
		var point := node.to_global(p)
		if (point.x > 0 and point.x < screen_size.x and
			point.y > 0 and point.y < screen_size.y ):
			return true
	return false


static func is_any_point_off_screen(node: Node2D, points: PackedVector2Array) -> bool:
	var screen_size := node.get_viewport_rect().size
	for p in points:
		var point := node.to_global(p)
		if not (
			point.x > 0 and point.x < screen_size.x and
			point.y > 0 and point.y < screen_size.y ):
			return true
	return false


static func is_node_on_screen_edge(node: Node2D, points: PackedVector2Array) -> bool:
	return (
		is_any_point_on_screen(node, points) and
		is_any_point_off_screen(node, points)
	)
