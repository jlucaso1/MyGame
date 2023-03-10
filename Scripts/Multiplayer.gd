# multiplayer.gd
extends Node

const PORT = 4433

func _ready() -> void:
	# Start paused.
	# You can save bandwidth by disabling server relay and peer notifications.
	multiplayer.server_relay = false

	# Automatically start the server in headless mode.
	if DisplayServer.get_name() == "headless":
		print("Automatically starting dedicated server.")
		_on_host_pressed.call_deferred()


func _on_host_pressed() -> void:
	# Start as server.
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer server.")
		return
	multiplayer.multiplayer_peer = peer
	start_game()


func _on_connect_pressed() -> void:
	# Start as client.
	var txt : String = %Remote.text
	if txt == "":
		OS.alert("Need a remote to connect to.")
		return
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(txt, PORT)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to start multiplayer client.")
		return
	multiplayer.multiplayer_peer = peer
	start_game()


func start_game() -> void:
	# Hide the UI and unpause to start the game.
	$UI.hide()
	if multiplayer.is_server():
		change_level.call_deferred(load("res://Scenes/MainScene.tscn"))
# Call this function deferred and only on the main authority (server).
func change_level(scene: PackedScene) -> void:
	# Remove old level if any.
	var level = $Level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	# Add new level.
	level.add_child(scene.instantiate())
