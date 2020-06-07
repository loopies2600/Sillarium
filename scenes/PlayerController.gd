extends KinematicBody2D

# Variables de otros objetos
onready var animPlayer = $Graphics/AnimationPlayer
onready var bodyAnim = $Graphics/Body
onready var arms = $Graphics/Body/Arms
onready var head = $Graphics/Body/Head
onready var startPos

# Variables para movimiento horizontal
export (float) var acceleration = 50
export (float) var maxSpeed = 400
export (float) var horDrag = 0.3

# Variables para movimiento vertical
export (float) var jumpBoost = 500
export (float) var maxFallSpeed = 800
export (float) var verDrag = 0.2
export (float) var gravity = 800

var velocity = Vector2()

func _ready():
	startPos = $"/root/World/StartPosition".position

func _physics_process(delta):
	# Gravedad
	velocity.y = min(velocity.y + gravity * delta, maxFallSpeed)
	
	# Variable que comprueba que el jugador no se trato de mover
	# horizontalmente
	var friction = false
	
	if Input.is_action_pressed("move_right"):
		velocity.x = min(velocity.x + acceleration, maxSpeed)
		UnflipGraphics()
	elif Input.is_action_pressed("move_left"):
		velocity.x = max(velocity.x - acceleration, -maxSpeed)
		FlipGraphics()
	else:
		friction = true
	
	if is_on_floor():
		if Input.is_action_just_pressed("jump"):
			velocity.y -= jumpBoost
			
		if friction:
			velocity.x = lerp(velocity.x, 0, horDrag)
			PlayIdleAnimation()
		else:
			PlayRunAnimation()
	else:
		if velocity.y < 0:
			PlayJumpAnimation()
		else:
			PlayFallAnimation()
			
		if friction:
			velocity.x = lerp(velocity.x, 0, verDrag)
	
	# Mueve al jugador
	velocity = move_and_slide(velocity, Globals.UP)

func Respawn():
	position = startPos

func PlayIdleAnimation():
	# Obvio
	animPlayer.play("Idle")
	bodyAnim.animation = "Idle"

func PlayRunAnimation():
	# Obvio
	animPlayer.play("Running")
	bodyAnim.animation = "Running"

func PlayJumpAnimation():
	#Obvio
	bodyAnim.animation = "Jumping"

func PlayFallAnimation():
	#Obvio
	bodyAnim.animation = "Falling"

func FlipGraphics():
	# Obvio
	bodyAnim.flip_h = true
	arms.flip_h = true
	head.flip_h = true

func UnflipGraphics():
	# Obvio
	bodyAnim.flip_h = false
	arms.flip_h = false
	head.flip_h = false
