extends Area2D

signal fruit_picked(id: String)

@export var points := 0

@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$PlayerInput.set_multiplayer_authority(id)
		
@onready var input := $PlayerInput

@onready var audio_player := $AudioPlayer as AudioStreamPlayer2D

func _ready() -> void:
	# Set the camera as current if we are this player.
	if player != multiplayer.get_unique_id():
		input.set_process(false)
		$Sprite2D.modulate = Color(Color.DARK_GRAY)
		audio_player.volume_db = -20
	else:
		z_index = 10

func _on_area_entered(area: Area2D) -> void:
	if not multiplayer.is_server(): return
	if area.is_in_group("Fruit"):
		emit_signal("fruit_picked", area.position)
		_add_point.rpc()
		
@rpc("call_local")
func _add_point() -> void:
	points += 1
	audio_player.play()
	if player == multiplayer.get_unique_id():
			get_window().title = "Coins: " + str(points)
