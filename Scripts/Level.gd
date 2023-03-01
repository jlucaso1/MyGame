# level.gd
extends Node2D

const SPAWN_RANDOM := 5.0

func _ready() -> void:
	# We only need to spawn players on the server.
	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_sync_item)

	# Spawn already connected players.
	for id in multiplayer.get_peers():
		add_player(id)

	# Spawn the local player unless this is a dedicated server export.
	if not OS.has_feature("dedicated_server"):
		add_player(1)


func _exit_tree() -> void:
	if not multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(del_sync_item)


func add_player(id: int) -> void:
	var character = preload("res://Prefabs/player.tscn").instantiate()
	# Set player id.
	character.player = id
	character.name = str(id)
	character.points = 0
	character.position = Vector2(0,0)
	character.connect("fruit_picked", $FruitController.delete_fruit)
	$MultiplayerObjects.add_child(character, true)

func del_sync_item(id: int) -> void:
	if not $MultiplayerObjects.has_node(str(id)):
		return
	$MultiplayerObjects.get_node(str(id)).queue_free()
