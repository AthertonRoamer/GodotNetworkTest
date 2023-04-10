extends Node

var player_scene = preload("res://player.tscn")

var world : Node

var player_info := {}

var players := 0
var spawns := []


		
func _ready():
	var sc1 = spawn_config.new()
	sc1.num = 1
	sc1.spawn_pos = Vector2(200, 200)
	var sc2 = spawn_config.new()
	sc1.num = 2
	sc1.spawn_pos = Vector2(200, 600)
	spawns = [sc1, sc2]
	
	
func preconfigure_game(full_player_info):
	player_info = full_player_info
	
	#create self
	var my_p = player_scene.instantiate()
	var my_id = get_tree().get_multiplayer().get_unique_id()
	var my_info = player_info[my_id]
	my_p.name = str(my_id)
	my_p.set_multiplayer_authority(my_id)
	my_p.player_name = my_info["player_name"]
#	var my_p_spawn = instance_from_id(my_info["spawn"].object_id)
	my_p.player_num = my_info["spawn_num"]
	my_p.position = my_info["spawn_pos"]
	world.add_child(my_p)
	
	#create others
	for p in player_info:
		if p == my_id:
			continue
		var player = player_scene.instantiate()
		var p_info = player_info[p]
		player.set_name(str(p))
		player.set_multiplayer_authority(p)
		player.player_name = p_info["player_name"]
#		var p_spawn = instance_from_id(p_info["spawn"].object_id)
		player.player_num = p_info["spawn_num"]
		player.position = p_info["spawn_pos"]
		player.active = false
		world.add_child(player)
	
	Lobby.submit_done_preconfiguring()

func add_player(id):
	players += 1 
	var p = player_scene.instantiate()
	p.name = str(id)
	p.player_num = players
	p.position.x = 300 * players
	p.position.y = 300
	world.add_child(p)
	
	
