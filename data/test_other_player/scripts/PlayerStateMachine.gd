extends KinematicBody2D

export (float) var horSpeed = 500
export (float) var jumpBoost = 950
export (float) var gravity = 2000
export (float) var maxFallSpeed = 4000
export (float, 0, 1) var aimWeight = 0.5

var currentState
var velocity = Vector2()
var inputHold = false

onready var anim = $Graphics/BodyAnimation
onready var head = $Graphics/HeadAnimation
onready var gun = $Gun
onready var states = {
	"Idle": $States/Idle,
	"Moving": $States/Moving,
}

func _ready():
	ChangeState("Idle")

func ChangeState(newState):
	currentState = states[newState]
	print("Player is now ", newState)

func _physics_process(delta):
	# Aplicar la gravedad y friccion
	ApplyGravity(delta)

	# Mover al jugador
	velocity = move_and_slide(velocity, Vector2.UP)

	# Actualizar el estado
	var updateState = currentState.HandleInput(self, delta)
	if updateState != null:
		ChangeState(updateState)

	HandleGunInput()

func HandleGunInput():

	var gunDirection = Vector2(
	int(Input.is_action_pressed("aim_right")) - int(Input.is_action_pressed("aim_left")),
	int(Input.is_action_pressed("aim_down")) - int(Input.is_action_pressed("aim_up")))

	# Variables para girar el arma
	var gunRotation
	var currentGunSpriteRotation = gun.sprite.global_rotation

	if gunDirection != Vector2.ZERO:
		# Encuentra el angulo al que se esta apuntando
		gunRotation = gunDirection.angle()

		# Gira el arma para que este alineada para disparar
		gun.RotateTo(gunRotation)

		# Espeja el sprite del jugador para que no dispare hacia atras
		if gunDirection.x == -1:
			FlipGraphics(true)
		elif gunDirection.x == 1:
			FlipGraphics(false)
		else:

			# Cambia la sprite de la cabeza dependiendo en direccion
			if gunDirection.y == 1:
				head.animation = "Down"
			elif gunDirection.y == -1:
				head.animation = "Up"

	else:
		# Si no hay input
		head.animation = "Side"

		# Gira el arma de acuerdo al sprite
		if anim.flip_h:
			gunRotation = PI
		else:
			gunRotation = 0

	# Gira el arma y el sprite
	gun.RotateTo(gunRotation)
	gun.sprite.global_rotation = currentGunSpriteRotation
	gun.sprite.global_rotation = lerp_angle(currentGunSpriteRotation, gunRotation, aimWeight)
	gun.ChangeSprite(anim.flip_h)

	if Input.is_action_pressed("shoot"):
			gun.Fire()

func ApplyGravity(delta):
	# Detiene al jugador si salta contra el techo
	if is_on_ceiling():
		velocity.y = 0

	# Annade velocidad a la caida
	velocity.y = min(velocity.y + gravity * delta, maxFallSpeed)

func FlipGraphics(flip):
	anim.flip_h = flip
	head.flip_h = flip
