extends Sprite2D

@onready var board_size := Config.board_size as Vector2i

func _ready() -> void:
	scale = board_size

