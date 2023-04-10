extends Area2D

var source := 0
var speed := 4
var dir := Vector2.UP

var free_distance := 1500

func _process(_delta):
	for a in get_overlapping_bodies():
		if a.is_in_group("player"):
			if source != a.player_num:
				a.hit()
				queue_free()
	position += speed * dir
	if position.length() > free_distance:
		queue_free()
