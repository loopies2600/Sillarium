extends KinematicBody2D

onready var animPlayer = $Graphics/AnimationPlayer
onready var bodyAnim = $Graphics/Body
onready var arms = $Graphics/Body/Arms
onready var head = $Graphics/Body/Head

export (float) var acceleration = 20
export (float) var maxSpeed = 400
export (float) var horDrag = 0.2

export (float) var jumpBoost = 500
export (float) var maxFallSpeed = 800
export (float) var verDrag = 0.1
export (float) var gravity = 800

var velocity = Vector2()

func _ready():
	pass

func _physics_process(delta):
	velocity.y = min(velocity.y + gravity * delta, maxFallSpeed)
	
	var friction = false
	if Input.is_action_pressed("move_right"):
		velocity.x = min(velocity.x + acceleration, maxSpeed)
		if is_on_floor():
			PlayRunAnimation()
		UnflipGraphics()
	elif Input.is_action_pressed("move_left"):
		velocity.x = max(velocity.x - acceleration, -maxSpeed)
		if is_on_floor():
			PlayRunAnimation()
		FlipGraphics()
	else:
		friction = true
		PlayIdleAnimation()
	
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y -= jumpBoost
			PlayIdleAnimation()
		if friction:
			velocity.x = lerp(velocity.x, 0, horDrag)
	else:
		if friction:
			velocity.x = lerp(velocity.x, 0, verDrag)
	
	velocity = move_and_slide(velocity, Globals.UP)

func PlayIdleAnimation():
	animPlayer.play("Idle")
	bodyAnim.animation = "Idle"

func PlayRunAnimation():
	animPlayer.play("Running")
	bodyAnim.animation = "Running"

func FlipGraphics():
	bodyAnim.flip_h = true
	arms.flip_h = true
	head.flip_h = true

func UnflipGraphics():
	bodyAnim.flip_h = false
	arms.flip_h = false
	head.flip_h = false
