extends KinematicBody2D
class_name Player, "res://sprites/ui/menu/player.png"

signal player_damaged(dm, bm)

export(Resource) var character

onready var health = character.health
onready var maxSpeed = character.maxSpeed
onready var airMaxSpeed = character.airMaxSpeed
onready var acceleration = character.acceleration
onready var friction = character.friction
onready var airFriction = character.airFriction
onready var jumpStrength = character.jumpStrength
onready var timeJumpApex = character.timeJumpApex
onready var fallMultiplier = character.fallMultiplier
onready var dashStrength = character.dashStrength
onready var dashDuration = character.dashDuration
onready var aimWeight = character.aimWeight
onready var bounceOff = character.bounceOff
onready var graceTime = character.graceTime

onready var headTextures = character.headTextures
onready var dashTexture = character.dashTexture

var velocity := Vector2()
var groundAngle = -1
var snapAngle := Vector2(0.0, Globals.MAX_FLOOR_ANGLE)
var gravity
var jumpForce

var currentDamage := 0
var currentBump := 0.0

var canInput := false
var snap := true
var flashing := false
var canDash := true

onready var stateMachine = $StateMachine
onready var graphics = $Graphics
onready var animator = $Graphics/PlayerAnimator
onready var graphicsAnimator = $GraphicsAnimator
onready var armsPos = $ArmsPosition
onready var body = $Graphics/Body
onready var head = $Graphics/Body/Head
onready var legs = $Graphics/Body/Legs
onready var shadow = $Graphics/Shadow
onready var hitbox = $CollisionShape2D
onready var camera = $Camera
onready var attackSound = $FiringSound
onready var gracePeriod = $GracePeriodTimer

onready var currentWeapon

func _ready():
	gracePeriod.connect("timeout", self, "_gracePeriodEnd")
	
	Globals.weapon = Objects.getWeapon(0, armsPos, z_index + 1)
	currentWeapon = Globals.weapon
	add_child(currentWeapon)
	
func _physics_process(delta):
	if canInput:
		handleWeaponInput(delta)
	else:
		currentWeapon.hide()
		
	flashBehaviour()
	
func pickUpWeapon(id):
	if currentWeapon != null:
		currentWeapon.queue_free()
		
	Globals.weapon = Objects.getWeapon(id, armsPos, z_index + 1)
	currentWeapon = Globals.weapon
	add_child(currentWeapon)
	reinitializeVars()
	
func animspeedAsVelocity():
	if getInputDirection():
		animator.playback_speed = velocity.x / maxSpeed
	else:
		animator.playback_speed = 1
	
func moveAndSnap(delta):
	gravity = (2 * jumpStrength) / pow(timeJumpApex, 2)
	jumpForce = gravity * timeJumpApex
	
	if is_on_ceiling():
		graphicsAnimator.play("bump")
		graphicsAnimator.queue("default")
		velocity.y = 0
		
	if !is_on_floor():
		velocity.y += gravity * delta * (fallMultiplier if velocity.y > 0 else 1)
		
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		groundAngle = collision.normal.angle()
	
	if snap:
		snapAngle = Vector2(0.0, Globals.MAX_FLOOR_ANGLE)
	else:
		snapAngle = Vector2()
		
	velocity = move_and_slide_with_snap(velocity, snapAngle, Globals.UP, true)
	
func flashBehaviour():
	if flashing:
		visible = !visible
		
func getInputDirection() -> int:
	if canInput:
		var inputDirection = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		return inputDirection
	else: return 0
	
func handleWeaponInput(_delta):
	currentWeapon.show()
	
	var weaponDirection = Vector2(
	int(Input.is_action_pressed("aim_right")) - int(Input.is_action_pressed("aim_left")),
	int(Input.is_action_pressed("aim_down")) - int(Input.is_action_pressed("aim_up")))
	
	if weaponDirection.y == 1 and is_on_floor():
		weaponDirection.y = 0
		
	var weaponRotation
	var currentWeaponSpriteRotation = currentWeapon.global_rotation

	if weaponDirection != Vector2.ZERO:
		weaponRotation = weaponDirection.angle()

		# Gira el arma para que este alineada para disparar
		currentWeapon.RotateTo(weaponRotation, aimWeight)
		
		# Espeja el sprite del jugador para que no dispare hacia atras
		if weaponDirection.x == -1:
			FlipGraphics(true)
		elif weaponDirection.x == 1:
			FlipGraphics(false)
			
	else:
		head.texture = headTextures[1]

		# Gira el arma de acuerdo al sprite
		if body.flip_h:
			weaponRotation = PI
		else:
			weaponRotation = 0
	
	# Gira el arma y el sprite
	currentWeapon.RotateTo(weaponRotation, aimWeight)
	currentWeapon.ChangeSprite(body.flip_h)

func FlipGraphics(flip):
	head.flip_h = flip
	body.flip_h = flip
	legs.flip_h = flip
	
func takeDamage(damage, bump = maxSpeed * -1 if body.flip_h else maxSpeed * 1):
	currentDamage = damage
	currentBump = bump
	emit_signal("player_damaged")

func reinitializeVars():
	maxSpeed = character.maxSpeed
	acceleration = character.acceleration
	friction = character.friction
	airFriction = character.airFriction
	jumpStrength = character.jumpStrength
	timeJumpApex = character.timeJumpApex
	fallMultiplier = character.fallMultiplier
	dashStrength = character.dashStrength
	aimWeight = character.aimWeight
	
func disableCollisionBox():
	hitbox.set_deferred("disabled", true)
	
func startGracePeriod():
	gracePeriod.wait_time = character.graceTime
	gracePeriod.start()
	
	set_collision_mask_bit(2, false)
	set_collision_mask_bit(3, false)
	
func kill():
	var respawner = Objects.spawn(24, global_position)
	
	Globals.player = null
	remove_child(camera)
	respawner.add_child(camera)
	queue_free()
	
func _gracePeriodEnd():
	visible = true
	flashing = false
	
	set_collision_mask_bit(2, true)
	set_collision_mask_bit(3, true)
