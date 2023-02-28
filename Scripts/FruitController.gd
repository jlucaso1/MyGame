extends Node

@onready var board_size := Config.board_size as Vector2i
@onready var fruit_prefab := preload("res://Prefabs/fruit.tscn")

var rng = RandomNumberGenerator.new()

func _ready():
	if multiplayer.is_server(): $Timer.start()

func _on_timer_timeout():
	spawn_fruit_random.rpc(get_random_position())

@rpc("call_local")
func spawn_fruit_random(fruit_position: Vector2):
	
	var fruit = fruit_prefab.instantiate()
	fruit.position = fruit_position
	%MultiplayerObjects.add_child(fruit)

@rpc("call_local")
func delete_fruit(fruit_position: Vector2):
	for fruit in %MultiplayerObjects.get_children():
		if fruit.is_in_group("Fruit") && fruit.position == fruit_position:
			fruit.queue_free()

func get_random_position() -> Vector2i:
	var new_fruit_position = Vector2i(rng.randi_range(0,board_size.x - 1), rng.randi_range(0,board_size.y - 1))
	for fruit in %MultiplayerObjects.get_children():
		if fruit.is_in_group("Fruit") && Vector2i(fruit.position) == new_fruit_position:
			return get_random_position()
	return new_fruit_position
