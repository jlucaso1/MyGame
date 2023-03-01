extends Node

@onready var board_size := Config.board_size as Vector2i
@onready var fruit_prefab := preload("res://Prefabs/fruit.tscn")

var rng := RandomNumberGenerator.new()

var fruitPositionsCached := []
var all_positions: Array

func _ready() -> void:
	if multiplayer.is_server(): 
		$Timer.start()
		all_positions = get_all_positions()
func _on_timer_timeout() -> void:
	spawn_fruit_random.rpc(get_empty_random_position())

@rpc("call_local")
func spawn_fruit_random(fruit_position: Vector2) -> void:
	
	var fruit = fruit_prefab.instantiate()
	fruit.position = fruit_position
	%MultiplayerObjects.add_child(fruit)
	fruitPositionsCached.append(fruit_position)

@rpc("call_local")
func delete_fruit(fruit_position: Vector2) -> void:
	for fruit in %MultiplayerObjects.get_children():
		if fruit.is_in_group("Fruit") && fruit.position == fruit_position:
			fruit.queue_free()
			fruitPositionsCached.erase(fruit_position)

func get_all_positions() -> Array:
	var positions = []
	for i in range(0, board_size.x):
		for j in range(0, board_size.y):
			positions.append(Vector2(i, j))
	return positions

func get_empty_random_position() -> Vector2i:
	var empty_positions = all_positions.filter(func(pos: Vector2i): return not fruitPositionsCached.has(pos))

	return empty_positions.pick_random()
