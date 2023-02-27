extends Node

@onready var board_size := %Config.get("board_size") as Vector2
@onready var fruit_prefab := preload("res://Prefabs/fruit.tscn")

var rng = RandomNumberGenerator.new()

func _on_timer_timeout():
	spawn_fruit_random()
	
func spawn_fruit_random():
	var new_fruit_position = Vector2(rng.randi_range(0,board_size.x - 1), rng.randi_range(0,board_size.y - 1))
	for fruit in get_children():
		if fruit.is_in_group("Fruit"):
			if(fruit.position == new_fruit_position):
				return spawn_fruit_random()
	var fruit = fruit_prefab.instantiate()
	fruit.position = Vector2(new_fruit_position)
	add_child(fruit)
