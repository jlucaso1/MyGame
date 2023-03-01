extends Node

@onready var board_size := Config.board_size as Vector2
@onready var fruit_prefab := preload("res://Prefabs/fruit.tscn")

var fruit_positions := []
var all_positions := []
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	if multiplayer.is_server(): 
		$Timer.start()
		all_positions = _get_all_positions()
	else:
		_request_restore_fruits.rpc(multiplayer.get_unique_id())

@rpc("any_peer")
func _request_restore_fruits(id: int) -> void:
	_restore_fruits.rpc_id(id, fruit_positions)
	
@rpc
func _restore_fruits(fruit_positions_from_server: Array) -> void:
	for fruit_position in fruit_positions_from_server:
		_spawn_fruit_at_position(fruit_position)

func _on_timer_timeout() -> void:
	_spawn_fruit_random.rpc(_get_empty_random_position())

func _spawn_fruit_at_position(fruit_position: Vector2) -> void:
	var fruit = fruit_prefab.instantiate()
	fruit.position = fruit_position
	%MultiplayerObjects.add_child(fruit)

@rpc("call_local")
func _spawn_fruit_random(fruit_position: Vector2) -> void:
	_spawn_fruit_at_position(fruit_position)
	if multiplayer.is_server(): 
		fruit_positions.append(fruit_position)

@rpc("call_local")
func delete_fruit(fruit_position: Vector2) -> void:
	for fruit in %MultiplayerObjects.get_children():
		if fruit.is_in_group("Fruit") && fruit.position == fruit_position:
			fruit.queue_free()
			if multiplayer.is_server(): 
				fruit_positions.erase(fruit_position)

func _get_all_positions() -> Array:
	var positions = []
	for i in range(0, board_size.x):
		for j in range(0, board_size.y):
			positions.append(Vector2(i, j))
	return positions

func _get_empty_random_position() -> Vector2:
	var empty_positions = all_positions.filter(func(pos: Vector2): return not fruit_positions.has(pos))
	return empty_positions.pick_random()
