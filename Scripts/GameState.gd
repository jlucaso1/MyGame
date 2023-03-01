extends Node

var _points := 0

func _ready() -> void:
	add_points(0)

func add_points(newPoints = 1) -> void:
	_points += newPoints
	
