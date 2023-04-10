extends RigidBody2D

const SPEED := 250

@export var player_num := 1
@export var active := true
@export var player_name := "Player"

var spawn : spawn_config


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
	$NameDisplay.text = player_name

func _integrate_forces(s):
	var lv : Vector2
	
	if active:
		up = Input.is_action_pressed("player_up")
		down = Input.is_action_pressed("player_down")
		left = Input.is_action_pressed("player_left")
		right = Input.is_action_pressed("player_right")
		fire = Input.is_action_just_pressed("player_fire")
		fire_direction = position.direction_to(get_global_mouse_position())
		rpc("set_up", up)
		rpc("set_down", down)
		rpc("set_right", right)
		rpc("set_left", left)
		rpc("set_fire", fire)
		rpc("set_fire_direction", fire_direction)
	
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

@rpc
func set_up(b):
	up = b

@rpc
func set_down(b):
	down = b
	
@rpc
func set_right(b):
	right = b
	
@rpc
func set_left(b):
	left = b

@rpc
func set_fire(b):
	fire = b
	
@rpc
func set_fire_direction(v):
	fire_direction = v
	
