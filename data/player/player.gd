extends KinematicBody2D

export (float) var maxSpeed = 400.0
export (float) var acceleration = maxSpeed / 2
export (float) var friction = acceleration
export (float) var jumpStrength = 150.0
export (float) var timeJumpApex = 0.4
export (float) var fallMultiplier = 1.5
export (float) var dashStrength = 1000.0
export (float) var cameraOffset = 1.5
export (float, 0, 1) var aimWeight = 0.5

export (Array, AtlasTexture) var headTextures
export (Texture) var playerNumberTexture

var velocity := Vector2()
var groundAngle = -1
var snap = true
var snapAngle := Vector2(0.0, Globals.MAX_FLOOR_ANGLE)

var gravity
var jumpForce

var weapon
var currentWeapon
var weaponIndex = 0

onready var stateMachine = $StateMachine
onready var animator = $Graphics/PlayerAnimator
onready var body = $Graphics/Body
onready var head = $Graphics/Body/Head
onready var legs = $Graphics/Body/Legs
onready var hitbox = $CollisionShape2D
onready var camera = $Camera2D

func _ready():
	Globals.set("player", self)
	$Graphics/PlayerNumber.texture = playerNumberTexture
	
	loadWeapon(weaponIndex)
	
func _physics_process(delta): 
	if Input.is_action_just_pressed("wps_left"):
		switchWeapon(-1)
	if Input.is_action_just_pressed("wps_right"):
		switchWeapon(1)
	
	animspeedAsVelocity()
	moveAndSnap(delta)
	handleWeaponInput(delta)
	
func animspeedAsVelocity():
	if velocity.x != 0:
		animator.playback_speed = velocity.x / maxSpeed
	else:
		animator.playback_speed = 1
	
func moveAndSnap(delta):
	gravity = (2 * jumpStrength) / pow(timeJumpApex, 2)
	jumpForce = gravity * timeJumpApex
	
	if is_on_ceiling():
		velocity.y = 0
		
	velocity.y += gravity * delta * (fallMultiplier if velocity.y > 0 else 1)
		
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		groundAngle = collision.normal.angle()
	
	if snap:
		snapAngle = Vector2(0.0, Globals.MAX_FLOOR_ANGLE)
	else:
		snapAngle = Vector2()
		
	velocity = move_and_slide_with_snap(velocity, snapAngle, Vector2(0, groundAngle), true)

func loadWeapon(weaponID):
	var inheritFireAngle = 0
	
	if weapon != null:
		inheritFireAngle = weapon.global_rotation
		weapon.queue_free()
		
	var wpsType = load(Globals.LoadJSON("res://data/json/weapons.json", weaponID)["file"])
	var wps = load(Globals.LoadJSON("res://data/json/weapons.json", weaponID)["type"])
	currentWeapon = wps
	weapon = currentWeapon.instance()
	weapon.type = wpsType
	weapon.global_rotation = inheritFireAngle
	weapon.armsPos = body
	add_child(weapon)
	
func switchWeapon(dir):
	weaponIndex += 1 * dir
	loadWeapon(weaponIndex)
	reinitializeVars()
		
func handleWeaponInput(delta):
	var weaponDirection = Vector2(
	int(Input.is_action_pressed("aim_right")) - int(Input.is_action_pressed("aim_left")),
	int(Input.is_action_pressed("aim_down")) - int(Input.is_action_pressed("aim_up")))

	# Variables para girar el arma
	var weaponRotation
	var currentGunSpriteRotation = weapon.global_rotation

	if weaponDirection != Vector2.ZERO:
		# Encuentra el angulo al que se esta apuntando
		weaponRotation = weaponDirection.angle()

		# Gira el arma para que este alineada para disparar
		weapon.RotateTo(weaponRotation)

		camera.offset_h = cameraOffset * weaponDirection.x
		camera.offset_v = cameraOffset * weaponDirection.y
		# Espeja el sprite del jugador para que no dispare hacia atras
		if weaponDirection.x == -1:
			FlipGraphics(true)
		elif weaponDirection.x == 1:
			FlipGraphics(false)
		else:

			# Cambia la sprite de la cabeza dependiendo en direccion
			if weaponDirection.y == 1:
				head.texture = headTextures[2]
			elif weaponDirection.y == -1:
				head.texture = headTextures[0]
				
	else:
		camera.offset_h = lerp(camera.offset_h, 0, 0.0001 * abs(camera.offset_h))
		camera.offset_v = lerp(camera.offset_v, 0, 0.0001 * abs(camera.offset_v))
		head.texture = headTextures[1]

		# Gira el arma de acuerdo al sprite
		if body.flip_h:
			weaponRotation = PI
		else:
			weaponRotation = 0

	# Gira el arma y el sprite
	weapon.RotateTo(weaponRotation)
	weapon.global_rotation = currentGunSpriteRotation
	weapon.global_rotation = lerp_angle(currentGunSpriteRotation, weaponRotation, aimWeight)
	weapon.ChangeSprite(body.flip_h)
	
func FlipGraphics(flip):
	head.flip_h = flip
	body.flip_h = flip
	legs.flip_h = flip

func reinitializeVars():
	maxSpeed = 400.0
	acceleration = maxSpeed / 2
	friction = acceleration
	jumpStrength = 150.0
	dashStrength = 1000.0
	gravity = 20.0
