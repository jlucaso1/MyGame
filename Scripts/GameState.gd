extends Node

var _points := 0

func _ready():
	add_points(0)

func add_points(newPoints = 1):
	_points += newPoints
	
