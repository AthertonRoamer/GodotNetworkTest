extends Label

func alert(s : String):
	text = s
	$Timer.start()


func _on_timer_timeout():
	text = ""
