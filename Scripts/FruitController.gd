extends Node

var fruit_positions := []
var all_positions := []
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	if multiplayer.is_server(): 
		$Timer.start()
		all_positions = _get_all_positions()
	
func _on_timer_timeout() -> void:
	if multiplayer.is_server():
		_spawn_fruit_random(_get_empty_random_position())

func _spawn_fruit_at_position(fruit_position: Vector2) -> void:
	var fruit = preload("res://Prefabs/fruit.tscn").instantiate()
	fruit.position = fruit_position
	fruit.name = str(fruit_position)
	%MultiplayerObjects.add_child(fruit, true)

func _spawn_fruit_random(fruit_position: Vector2) -> void:
	_spawn_fruit_at_position(fruit_position)
	
	fruit_positions.append(fruit_position)

func delete_fruit(fruit_name: String) -> void:
	var fruit = %MultiplayerObjects.get_node(fruit_name)
	fruit_positions.erase(fruit.position)
	fruit.queue_free()

func _get_all_positions() -> Array:
	var board_size = Config.board_size as Vector2i
	var positions = []
	for i in range(0, board_size.x):
		for j in range(0, board_size.y):
			positions.append(Vector2(i, j))
	return positions

func _get_empty_random_position() -> Vector2:
	var empty_positions = all_positions.filter(func(pos: Vector2): return not fruit_positions.has(pos))
	return empty_positions.pick_random()
