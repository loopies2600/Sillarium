extends "../behaviour/basic_enemy_controller.gd"

onready var parentSprite = $Body
onready var animator = $AnimationPlayer

export (PackedScene) var flames

var MAX_SPEED = 600
var JUMP_MAGNITUDE = 600
const GRAVITY = 25
const ACCELERATION = 25
const FRICTION = 0.15
var velocity = Vector2()
var dir = 1
var friction = false
enum states {IDLE, WALK, JUMP, LAND}
var state = states.IDLE
var stateTimer = 50

func _ready():
	hitbox = $Area2D
	animator.play("SpitFire")
	var _unused = $FlameTimer.connect("timeout", self, "throw_flame")
	_unused = connect("DestroySelf", self, "OnDestruction")
	
func _physics_process(_delta):
	velocity.y += GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP, true, 60, 1)
	
	stateTimer = 1
	
	match state:
		states.IDLE:
			velocity.x = lerp(velocity.x, 0, 0.1)
			
			if stateTimer <= 0:
				velocity.y = -JUMP_MAGNITUDE
				randomize_movement()
				change_state(states.JUMP)
		
		states.WALK:
			scale.x = dir
			if is_on_wall():
				dir = -dir
			
			match dir:
				1:
					velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
				-1:
					velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
			
			Globals.CreateTrail(0.1, parentSprite.texture, parentSprite.global_position, parentSprite.global_rotation, parentSprite.global_scale, -128)
			for _i in parentSprite.get_children():
				Globals.CreateTrail(0.1, _i.texture, _i.global_position, _i.global_rotation, _i.global_scale, -128)
		
		states.JUMP:
			match dir:
				1:
					velocity.x = min(velocity.x + ACCELERATION, MAX_SPEED)
				-1:
					velocity.x = max(velocity.x - ACCELERATION, -MAX_SPEED)
			
			if is_on_floor():
				change_state(states.LAND)
		
		states.LAND:
			velocity = Vector2.ZERO
			
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

func throw_flame():
	var newFlame = flames.instance()
	newFlame.position = position + Vector2(64, 0)
	get_tree().get_root().add_child(newFlame)
	
func OnDestruction():
	queue_free()
