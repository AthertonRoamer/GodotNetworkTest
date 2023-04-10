extends Control

var w = preload("res://world.tscn")

func _on_serve_pressed():
	Data.is_server = true
	Data.ip = $LineEdit.text
	get_tree().change_scene_to_packed(w)

func _on_play_pressed():
	Data.is_server = false
	Data.ip = $LineEdit.text
	Data.player_name = $LineEdit2.text
	get_tree().change_scene_to_packed(w)
	
