extends Area2D

var commands := {
	"ui_right": func lambda(): position.x += 1,
	"ui_left": func lambda(): position.x -= 1,
	"ui_up": func lambda(): position.y -= 1,
	"ui_down": func lambda(): position.y += 1
}

func _process(_delta):
	_process_commands()
	
func _process_commands():
	for action in InputMap.get_actions():
		if Input.is_action_just_pressed(action) && commands.has(action):
			commands[action].call()


func _on_area_entered(area):
	if(area.is_in_group("Fruit")):
		area.queue_free()
		%GameState.get("add_points").call()
