extends Sprite2D

@onready var board_size = Config.board_size

func _ready():
	scale = board_size

