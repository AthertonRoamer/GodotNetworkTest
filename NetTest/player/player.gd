extends RigidBody2D

const SPEED := 250

@export var player_num := 1
@export var active := true


var up : bool
var down : bool
var left : bool
var right : bool
var fire : bool
var fire_direction := Vector2.UP

var hits := 0

func _ready():
	if player_num == 2:
		$Sprite2D.texture = load("res://art/filler_player2.png")

func _integrate_forces(s):
	if active:
		var lv : Vector2
		
		up = Input.is_action_pressed("player_up")
		down = Input.is_action_pressed("player_down")
		left = Input.is_action_pressed("player_left")
		right = Input.is_action_pressed("player_right")
		fire = Input.is_action_just_pressed("player_fire")
		
		fire_direction = position.direction_to(get_global_mouse_position())
	
		if up:
			lv.y -= 1 
		if down:
			lv.y += 1
		if left:
			lv.x -= 1 
		if right:
			lv.x += 1
		if fire:
			print("firing")
			Game.world.add_bullet(position + 32 * fire_direction, player_num, fire_direction)
		
		lv = lv.normalized()
	
		lv *= SPEED
	
		s.set_linear_velocity(lv)
		

func hit():
	hits += 1
	prints(str(player_num)+":", "hit")
	$Label.alert("hit: " + str(hits))
	
