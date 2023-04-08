extends Node

var my_info := {}

func start_server():
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(Data.server_port, Data.max_players)
	print("err: " + str(err))
	get_tree().get_multiplayer().multiplayer_peer = peer
#	get_tree().set_multiplayer(peer)
	start_lobby()
	
func start_client():
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(Data.ip, Data.server_port)
	print("err: " + str(err))
	get_tree().get_multiplayer().multiplayer_peer = peer
#	get_tree().set_multiplayer(peer)

func start_lobby():
	var mult = get_tree().get_multiplayer()
	mult.peer_connected.connect(_player_connected)
	mult.peer_disconnected.connect(_player_disconnected)
	
func _player_connected(id : int):
	Game.world.get_node("Waiting").visible = false
	print("recieved connection!")
	
func _player_disconnected(id : int):
	pass
