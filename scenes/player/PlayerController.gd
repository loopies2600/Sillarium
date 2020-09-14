extends KinematicBody2D

# Variables de otros objetos
onready var animPlayer = $Graphics/AnimationPlayer
onready var bodyAnim = $Graphics/Body
onready var arms = $Graphics/Body/Arms
onready var head = $Graphics/Body/Head
onready var startPos
onready var debugDirection = $Graphics/Debug/direction
onready var debugHold = $Graphics/Debug/debug_hold
onready var cooldownTimer = $CooldownTimer
onready var firingSound = $FiringSound

export (PackedScene) var bullet
export (float) var cooldown = 0.85
export (int) var rotationSpeed = 4

# Variables para movimiento horizontal
export (float) var acceleration = 50
export (float) var maxSpeed = 400
export (float) var horDrag = 0.3

# Variables para movimiento vertical
export (float) var jumpBoost = 500
export (float) var maxFallSpeed = 800
export (float) var verDrag = 0.2
export (float) var gravity = 800

var dir = 1
var velocity = Vector2()
var fireAngle = 0
var angleDir = 1
var crosshairOffset = Vector2(180, 0)
var cooldownIsOver = true
var isShooting = false

func _ready():
	# Aqui hay un bug, si la escena no tiene
	# World/StartPosition, crashea, pero no encontre
	# manera de checkear si este node tiene un parent
	# WORKAROUND QUE HICE, JSJSJJSJSJSJSJSJSJSJSJSJJS
	if get_parent().get_node("StartPosition") == null:
		position = Vector2.ZERO
	else:
		position = $"/root/World/StartPosition".position
	cooldownTimer.wait_time = cooldown
	cooldownTimer.connect("timeout", self, "OnCooldown")

func _physics_process(delta):
	# Gravedad
	velocity.y = min(velocity.y + gravity * delta, maxFallSpeed)
	
	# Variable que comprueba que el jugador no se trato de mover
	# horizontalmente
	var friction = false

	# no necesito explicar lo que hace, pero si queres escribirlo
	var inputHold = false
	
	if Input.is_action_pressed("input_hold") and is_on_floor():
		inputHold = true
	
	# Recibe input para movimiento horizontal
	if Input.is_action_pressed("move_right") and !inputHold:
		velocity.x = min(velocity.x + acceleration, maxSpeed)
		dir = 1
		bodyAnim.flip_h = false
	elif Input.is_action_pressed("move_left") and !inputHold:
		velocity.x = max(velocity.x - acceleration, -maxSpeed)
		dir = -1
		bodyAnim.flip_h = true
	else:
		friction = true
	
	if is_on_floor():
		# Mata al jugador si esta siendo aplastado
		if is_on_ceiling():
			Respawn()
		
		# Salta
		if Input.is_action_pressed("jump") and !inputHold:
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
	
	# Obtiene input de ocho direcciones
	GetLookInput()

func GetLookInput():
		var fireDirection = Vector2()
	
		var LLEFT = Input.is_action_pressed("look_left")
		var LRIGHT = Input.is_action_pressed("look_right")
		var LUP = Input.is_action_pressed("look_up")
		var LDOWN = Input.is_action_pressed("look_down")
		# Pone la direccion correcta
		fireDirection = Vector2(int(LRIGHT) - int(LLEFT), int(LDOWN) - int(LUP))
		
		if LLEFT || LRIGHT || LUP || LDOWN:
			fireAngle = lerp_angle(fireAngle, fireDirection.angle(), 0.2)
	
		if Input.is_action_pressed("shoot") and cooldownIsOver:
			Shoot()
	
		arms.rotation = fireAngle
		debugDirection.position = crosshairOffset.rotated(fireAngle)

func Shoot():
	cooldownIsOver = false
	var newBullet = bullet.instance()
	var bulletOffset = Vector2(64, 0)
	newBullet.global_position = global_position + bulletOffset.rotated(fireAngle) + Vector2(randi() % 9, randi() % 9 -8)
	newBullet.rotation = fireAngle
	newBullet.z_index = arms.z_index - 1
	firingSound.pitch_scale = rand_range(0, 2)
	firingSound.play()
	get_tree().get_root().add_child(newBullet)
	cooldownTimer.start()

func OnCooldown():
	cooldownIsOver = true

func CheckForPushable():
	# Variables para verificar que el jugador este en contacto con el suelo
	var isOnEnvironment = false
	var pushable
	
	# Revisa cada objeto con el que esta en contacto
	for currentBody in get_slide_count():
		var body = get_slide_collision(currentBody).collider
		if body != null:
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
	position = $"/root/World/StartPosition".position

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
