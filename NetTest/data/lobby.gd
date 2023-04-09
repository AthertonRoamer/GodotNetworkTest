extends Node

var my_info := {}

func start_server():
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(Data.server_port, Data.max_players)
	print("server err: " + str(err))
	get_tree().get_multiplayer().multiplayer_peer = peer
#	get_tree().set_multiplayer(peer)
	start_lobby()
	

func start_lobby():
	var mult = get_tree().get_multiplayer()
	mult.peer_connected.connect(_player_connected)
	mult.peer_disconnected.connect(_player_disconnected)
	
func start_client():
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_client(Data.ip, Data.server_port)
	print("client err: " + str(err))
	get_tree().get_multiplayer().multiplayer_peer = peer
#	get_tree().set_multiplayer(peer)

	var mult = get_tree().get_multiplayer()
	mult.peer_connected.connect(_player_connected)
	mult.peer_disconnected.connect(_player_disconnected)
	mult.connected_to_server.connect(_connected_to_server)
	mult.connection_failed.connect(_connection_failed)
	mult.server_disconnected.connect(_server_disconnected)

	
func _player_connected(id : int):
	Game.world.get_node("Waiting").visible = false
	print("recieved connection!")
#	if Data.is_server:
#		rpc_id(id, "lobby_preconfigure_game")

@rpc
func lobby_preconfigure_game():
	print("we've been told to preconfigure")
	Game.add_player(1)
	
@rpc("any_peer")
func register_player(info):
	if Data.is_server:
		var id = get_tree().get_multiplayer().get_remote_sender_id()
#		Game.player_info[id] = info
		rpc("lobby_preconfigure_game")
	
func _player_disconnected(id : int):
	pass
	
func _connected_to_server():
	print("reached server")
	rpc("register_player", my_info)
	
func _server_disconnected():
	print("lost connection to server")
	
func _connection_failed():
	print("failed to reach server")
