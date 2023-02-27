extends Sprite2D

@onready var board_size = %Config.get("board_size")

func _ready():
	scale = board_size

