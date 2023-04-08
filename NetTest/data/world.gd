extends Node2D

var missile_scene := preload("res://missile.tscn")

func _ready():
	Game.world = self
	if Data.is_server:
		begin_game()
	else:
		join_game()


func begin_game():
	var peer = ENetMultiplayerPeer.new()
	var _err = peer.create_server(Data.server_port, Data.max_players)
	get_tree().get_multiplayer().multiplayer_peer = peer
#	get_tree().set_multiplayer(peer)
	Lobby.start_lobby()
	
func join_game():
	var peer = ENetMultiplayerPeer.new()
	var _err = peer.create_client(Data.ip, Data.server_port)
	get_tree().get_multiplayer().multiplayer_peer = peer
#	get_tree().set_multiplayer(peer)
	
func add_bullet(pos : Vector2, source : int, dir : Vector2):
	var m := missile_scene.instantiate()
	m.position = pos
	m.source = source
	m.dir = dir
	call_deferred("add_child", m)
	

