extends KinematicBody2D

onready var animSprite = $Body/RightFoot
onready var animator = $AnimationPlayer

var MAX_SPEED = 50
var JUMP_MAGNITUDE = 600
const GRAVITY = 25
const ACCELERATION = 25
const FRICTION = 0.15
var motion = Vector2()
var dir = 1
var friction = false
enum states {IDLE, JUMP, LAND}
var state = states.IDLE
var stateTimer = 50

func _ready():
	animator.play("Idle")
	
func _physics_process(delta):
	motion.y += GRAVITY
	
	motion = move_and_slide(motion, Vector2.UP)
	
	stateTimer = 1
	
	if (animSprite.frame == 1 || animSprite.frame == 12):
		animSprite.offset.y = -12
	else:
		animSprite.offset.y = 0
	
	match state:
		states.IDLE:
			motion.x = lerp(motion.x, 0, 0.1)
			
			if stateTimer <= 0:
				motion.y = -JUMP_MAGNITUDE
				randomize_movement()
				change_state(states.JUMP)
		
		states.JUMP:
			match dir:
				1:
					motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
				-1:
					motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
			
			if is_on_floor():
				change_state(states.LAND)
		
		states.LAND:
			motion = Vector2.ZERO
			
			if stateTimer <= 0:
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
