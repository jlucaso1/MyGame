extends Area2D

signal fruit_picked(id: String)

@export var points := 0

@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$PlayerInput.set_multiplayer_authority(id)
		
@onready var input = $PlayerInput

func _ready():
	# Set the camera as current if we are this player.
	if player != multiplayer.get_unique_id():
		input.set_process(false)
		$Sprite2D.modulate = Color(Color.DARK_GRAY)
	else:
		z_index = 10

func _on_area_entered(area: Area2D):
	if not multiplayer.is_server(): return
	if area.is_in_group("Fruit"):
		emit_signal("fruit_picked", area.position)
		_add_point.rpc()
		
@rpc("call_local")
func _add_point():
	points += 1
	if player == multiplayer.get_unique_id():
			get_window().title = "Coins: " + str(points)
