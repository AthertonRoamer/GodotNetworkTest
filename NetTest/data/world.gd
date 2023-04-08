extends Node2D

var missile_scene := preload("res://missile.tscn")

func _ready():
	Game.world = self
	if Data.is_server:
		Lobby.start_server()
	else:
		Lobby.start_client()



	

	
func add_bullet(pos : Vector2, source : int, dir : Vector2):
	var m := missile_scene.instantiate()
	m.position = pos
	m.source = source
	m.dir = dir
	call_deferred("add_child", m)
	

