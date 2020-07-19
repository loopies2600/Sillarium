extends KinematicBody2D

var MAX_SPEED = 50
var JUMP_MAGNITUDE = 600
const GRAVITY = 25
const ACCELERATION = 25
const FRICTION = 0.15
var motion = Vector2()
var dir = 1
var friction = false
onready var animSprite = $Graphics
enum states {IDLE, JUMP, LAND}
var state = states.IDLE
var stateTimer = 50

func _ready():
	pass
	
func _physics_process(delta):
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, Vector2.UP)
	
	animation_checking()
	
	stateTimer -= 1
	match state:
		states.IDLE:
			animSprite.offset.y = lerp(animSprite.offset.y, 0, 0.1)
			animSprite.scale = lerp(animSprite.scale, Vector2(1, 1), 0.1)
			motion.x = lerp(motion.x, 0, 0.1)
			
			if stateTimer <= 0:
				animSprite.offset.y = 0
				motion.y = -JUMP_MAGNITUDE
				randomize_movement()
				change_state(states.JUMP)
		
		states.JUMP:
			animSprite.offset.y = 0
			
			match dir:
				1:
					animSprite.rotation_degrees += 5
					motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
					animSprite.flip_h = true
				-1:
					animSprite.rotation_degrees -= 5
					motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
					animSprite.flip_h = false
			
			if is_on_floor():
				animSprite.scale = Vector2(1.1, 0.9)
				animSprite.offset.y = 48
				change_state(states.LAND)
		
		states.LAND:
			motion = Vector2.ZERO
			animSprite.offset.y = lerp(animSprite.offset.y, 24, 0.1)
			animSprite.scale = lerp(animSprite.scale, Vector2(1, 1), 0.1)
			animSprite.rotation_degrees = lerp(animSprite.rotation_degrees, 0, 0.75)
			
			if stateTimer <= 0:
				animSprite.offset.y = -16
				animSprite.scale = Vector2(0.8, 1.2)
				change_state(states.IDLE)
				
func choose_random(int_list):
	return int_list[randi() % int_list.size()]
	
func randomize_movement():
	dir = choose_random([-1, 1])
	MAX_SPEED = choose_random([50, 100, 150, 200])
	JUMP_MAGNITUDE = choose_random([600, 700, 800, 900])
	
func change_state(new_state):
	stateTimer = choose_random([8, 16, 32, 64])
	state = new_state
	
func animation_checking():
	if is_on_floor():
		match state:
			states.IDLE:
				animSprite.play("idle")
			states.LAND:
				animSprite.play("land")
	else:
		if motion.y <= 0:
			animSprite.play("jump")
