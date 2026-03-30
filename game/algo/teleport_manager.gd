extends Node2D

var grid: Array = []


func _ready() -> void:
	for i in range(8):
		var row: Array[int] = []
		for j in range(8):
			row.append(0)
		grid.append(row)

	print(grid)
