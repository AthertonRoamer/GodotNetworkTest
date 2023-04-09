extends Node

var player_scene = preload("res://player.tscn")

var world : Node

var player_info := []

var players := 0

func add_player(id):
	players += 1 
	var p = player_scene.instantiate()
	p.name = str(id)
	p.player_num = players
	p.position.x = 300 * players
	p.position.y = 300
	world.add_child(p)
	
