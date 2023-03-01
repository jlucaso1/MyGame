extends Node
@onready var board_size := Config.board_size as Vector2
@onready var player := $".."

var commands := {
	"ui_right": func(): player.position.x += 1,
	"ui_left": func(): player.position.x -= 1,
	"ui_up": func(): player.position.y -= 1,
	"ui_down": func(): player.position.y += 1
}

var limiters := {
	"ui_right": func(): return player.position.x + 1 < board_size.x,
	"ui_left": func(): return player.position.x > 0,
	"ui_up": func(): return player.position.y > 0,
	"ui_down": func(): return player.position.y + 1 < board_size.y,
}


func _process(_delta: float) -> void:
	_process_commands()

@rpc("call_local")
func _callback(action: String) -> void:
	if limiters.has(action) && !limiters[action].call(): return
	commands[action].call()
	

func _process_commands():
	for action in InputMap.get_actions():
		if Input.is_action_just_pressed(action) && commands.has(action):
			_callback.rpc(action)

