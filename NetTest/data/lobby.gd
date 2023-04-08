extends Node

var my_info := {}

func start_lobby():
	var mult = get_tree().get_multiplayer()
	mult.peer_connected.connect(_player_connected)
	mult.peer_disconnected.connect(_player_disconnected)
	
func _player_connected(id : int):
	Game.add_player(id)
	
func _player_disconnected(id : int):
	pass
