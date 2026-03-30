class_name Utils
extends Node

static func is_any_point_on_screen(node: Node2D, shape_obj: Variant) -> bool:
	var screen_size := node.get_viewport_rect().size
	var points: PackedVector2Array = dispatch_to_points(shape_obj)
	for p in points:
		var point := node.to_global(p)
		if (point.x > 0 and point.x < screen_size.x and
			point.y > 0 and point.y < screen_size.y ):
			return true
	return false


static func is_all_points_on_screen(node: Node2D, shape_obj: Variant) -> bool:
	var screen_size := node.get_viewport_rect().size
	var points: PackedVector2Array = dispatch_to_points(shape_obj)
	for p in points:
		var point := node.to_global(p)
		if not (point.x > 0 and point.x < screen_size.x and
			point.y > 0 and point.y < screen_size.y ):
			return false
	return true


static func is_any_point_off_screen(node: Node2D, shape_obj: Variant) -> bool:
	var screen_size := node.get_viewport_rect().size
	var points: PackedVector2Array = dispatch_to_points(shape_obj)
	for p in points:
		var point := node.to_global(p)
		if not (
			point.x > 0 and point.x < screen_size.x and
			point.y > 0 and point.y < screen_size.y ):
			return true
	return false


static func is_all_points_off_screen(node: Node2D, shape_obj: Variant) -> bool:
	return not is_all_points_on_screen(node, shape_obj)


static func is_node_on_screen_edge(node: Node2D, shape_obj: Variant) -> bool:
	return (
		is_any_point_on_screen(node, shape_obj) and
		is_any_point_off_screen(node, shape_obj)
	)


static func dispatch_to_points(shape_obj: Variant) -> PackedVector2Array:
	var res: PackedVector2Array
	if shape_obj is Polygon2D:
		res = shape_obj.polygon
	elif shape_obj is CollisionShape2D:
		var shape_rect: Rect2 = shape_obj.shape.get_rect()
		res = [
			shape_rect.position,
			shape_rect.position + Vector2(shape_rect.size.x, 0),
			shape_rect.position + Vector2(0, shape_rect.size.y),
			shape_rect.end,
		]
	else:
		assert(false, "Unknown type of shape")
	return res
