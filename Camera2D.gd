extends Camera2D

@onready var board_size = %Config.get("board_size")
@export var zoom_factor = 1.0

func _ready():
	get_tree().get_root().connect("size_changed", _resize)
	_resize()

func _resize():
	var viewport_size = get_viewport_rect().size
	var aspect_ratio = viewport_size.x / viewport_size.y
	var board_width = board_size.x
	var board_height = board_size.y
	if board_width / board_height < aspect_ratio:
		board_width = board_height * aspect_ratio
	else:
		board_height = board_width / aspect_ratio
	var zoom_y = viewport_size.y / board_height
	var zoom_x = viewport_size.x / board_width
	set_zoom(Vector2(zoom_x, zoom_y) * zoom_factor)
	set_position(Vector2(0, 0))
