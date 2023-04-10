extends Node

var my_info := {}
var players_joined := 0
var players_finished_preconfiguring := 0

func start_server():
	var peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(Data.server_port, Data.players)
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
#	connect signals to functions
	var mult = get_tree().get_multiplayer()
	mult.peer_connected.connect(_player_connected)
	mult.peer_disconnected.connect(_player_disconnected)
	mult.connected_to_server.connect(_connected_to_server)
	mult.connection_failed.connect(_connection_failed)
	mult.server_disconnected.connect(_server_disconnected)
	
func _connected_to_server():
	print("reached server")
	my_info["player_name"] = Data.player_name
	rpc_id(1, "register_player", my_info)
	
@rpc("any_peer")
func register_player(info):
	if Data.is_server:
		var id = get_tree().get_multiplayer().get_remote_sender_id()
		players_joined += 1
		info["player_name"] = Data.player_name
		for s in Game.spawns:
			if !s.taken:
				s.taken = true
#				rpc("set_spawn", s)
				info["spawn"] = s
				break
		Game.player_info[id] = info
		if players_joined == Data.players:
			rpc("lobby_preconfigure_game", Game.player_info)
			
@rpc
func set_spawn(s : spawn_config):
	Data.spawn = s

			
@rpc
func lobby_preconfigure_game(full_player_info):
	print("we've been told to preconfigure")
	get_tree().paused = true
	Game.preconfigure_game(full_player_info)
	
func submit_done_preconfiguring():
	rpc_id(1, "done_preconfiguring")

@rpc("any_peer")
func done_preconfiguring():
	if Data.is_server:
		players_finished_preconfiguring += 1
		if players_finished_preconfiguring == players_joined:
			rpc("start_game")
			
@rpc
func start_game():
	get_tree().paused = false
	
		
func _player_connected(id : int):
	Game.world.get_node("Waiting").visible = false
	print("recieved connection!")
#	if Data.is_server:
#		rpc_id(id, "lobby_preconfigure_game")

	
	
func _player_disconnected(id : int):
	pass
	
	
func _server_disconnected():
	print("lost connection to server")
	
func _connection_failed():
	print("failed to reach server")
