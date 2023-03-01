extends Sprite2D

@onready var board_size := Config.board_size as Vector2

func _ready() -> void:
	scale = board_size

