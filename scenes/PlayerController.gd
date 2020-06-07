extends KinematicBody2D

onready var animPlayer = $Graphics/AnimationPlayer
var speed = 400
var smoothing = 25

var velocity = Vector2()
var jump_magnitude = 600

func _ready():
	animPlayer.play("PlayerIdle")

func _physics_process(delta):
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = speed

	elif Input.is_action_pressed("ui_left"):
		velocity.x = -speed
		
	if velocity.x > 0:
			velocity.x -= smoothing
	elif velocity.x < 0:
			velocity.x += smoothing
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = -jump_magnitude
		
	velocity = move_and_slide(velocity, Globals.UP)
	velocity.y += Globals.gravity
	
