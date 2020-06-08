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
	
	# Recibe input para movimiento horizontal
	if Input.is_action_pressed("move_right"):
		velocity.x = min(velocity.x + acceleration, maxSpeed)
		UnflipGraphics()
	elif Input.is_action_pressed("move_left"):
		velocity.x = max(velocity.x - acceleration, -maxSpeed)
		FlipGraphics()
	else:
		friction = true
	
	if is_on_floor():
		
		# Mata al jugador si esta siendo aplastado
		if is_on_ceiling():
			Respawn()
		
		# Salta
		if Input.is_action_just_pressed("jump"):
			velocity.y -= jumpBoost
		
		# Quita velocidad x en el suelo
		if friction:
			velocity.x = lerp(velocity.x, 0, horDrag)
			PlayIdleAnimation()
		else:
			PlayRunAnimation()
		
		# Checkea si el jugador esta en colision con algo
		if get_slide_count() > 0:
			CheckForPushable()
	else:
		# Pone la animacion dependiendo de si esta subiendo o cayendo
		if velocity.y < 0:
			PlayJumpAnimation()
		else:
			PlayFallAnimation()
		# Quita velocidad x en el aire
		if friction:
			velocity.x = lerp(velocity.x, 0, verDrag)
	
	# Mueve al jugador
	velocity = move_and_slide(velocity, Globals.UP)

func CheckForPushable():
	# Variables para verificar que el jugador este en contacto con el suelo
	var isOnEnvironment = false
	var pushable
	
	# Revisa cada objeto con el que esta en contacto
	for currentBody in get_slide_count():
		var body = get_slide_collision(currentBody).collider
		if body.is_in_group("Pushable"):
			pushable = body
		elif body.is_in_group("Environment"):
			isOnEnvironment = true
	
	# Empuja el pushable si tambien esta en contacto con el suelo
	if isOnEnvironment and pushable != null:
		pushable.Push(velocity.x)

func Respawn():
	# Pone al jugador en la posicion original
	# WIP (anadir animacion y varas asi)
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
