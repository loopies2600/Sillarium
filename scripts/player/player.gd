extends KinematicBody2D
class_name Player, "res://sprites/ui/menu/player.png"

signal player_grounded_updated(isGrounded)
signal player_damaged(dm, bm)

export(Resource) var character
onready var dashTexture = character.dashTexture

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

var lastGoodPosition := Vector2()

var isGrounded := true
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
onready var dash = $Graphics/Body/Dash
onready var hitbox = $CollisionShape2D
onready var camera = $Camera
onready var attackSound = $FiringSound
onready var gracePeriod = $GracePeriodTimer

onready var bodyParts = [head, body, legs, dash]

onready var currentWeapon

func _ready():
	dash.texture = dashTexture
	
	Globals.weapon = Objects.getWeapon(0, armsPos, z_index + 1)
	currentWeapon = Globals.weapon
	add_child(currentWeapon)
	
func connectSignals():
	Objects.currentWorld.connect("level_initialized", self, "_onLevelInit")
	Objects.currentWorld.connect("level_started", self, "_onLevelStart")
	gracePeriod.connect("timeout", self, "_gracePeriodEnd")
	camera.connectToManipulators()
	
func _onLevelInit():
	canInput = false
	
func _onLevelStart():
	startGracePeriod()
	canInput = true
	
func _physics_process(delta):
	groundCheck()
	handleWeaponInput(delta)
	flashBehaviour()
	
func groundCheck():
	var wasGrounded = isGrounded
	isGrounded = is_on_floor()
	
	if wasGrounded == null || isGrounded != wasGrounded:
		emit_signal("player_grounded_updated", isGrounded)
		lastGoodPosition = position
		
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
	
func playRandomAnim(anims : Array):
	randomize()
	var animToPlay = randi() % anims.size()
	animator.play(anims[animToPlay])
	
func moveAndSnap(delta):
	gravity = (2 * jumpStrength) / pow(timeJumpApex, 2)
	jumpForce = gravity * timeJumpApex
	
	if !is_on_floor():
		velocity.y += gravity * delta * (fallMultiplier if velocity.y > 0 else 1)
	
	if is_on_ceiling():
		graphicsAnimator.play("bump")
		graphicsAnimator.queue("default")
		
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
	
func getFacingDirection() -> int:
	var facingDirection = -1 if body.flip_h else 1
	return facingDirection
	
func handleWeaponInput(_delta):
	if canInput:
		currentWeapon.set_process(true)
		var weaponDirection = Vector2(
		int(Input.is_action_pressed("aim_right")) - int(Input.is_action_pressed("aim_left")),
		int(Input.is_action_pressed("aim_down")) - int(Input.is_action_pressed("aim_up")))
		
		if weaponDirection.y == 1 and is_on_floor():
			weaponDirection.y = 0
			
		var weaponRotation

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
			# Gira el arma de acuerdo al sprite
			if body.flip_h:
				weaponRotation = PI
			else:
				weaponRotation = 0
		
		# Gira el arma y el sprite
		currentWeapon.RotateTo(weaponRotation, aimWeight)
		currentWeapon.ChangeSprite(body.flip_h)
		
	else:
		currentWeapon.set_process(false)

func FlipGraphics(flip):
	for part in bodyParts:
		part.flip_h = flip
	
func takeDamage(damage, bump = maxSpeed * -1 if body.flip_h else maxSpeed * 1):
	currentDamage = damage
	currentBump = bump
	emit_signal("player_damaged")

func reinitializeVars():
	dash.texture = dashTexture
	
	maxSpeed = character.maxSpeed
	acceleration = character.acceleration
	friction = character.friction
	airFriction = character.airFriction
	jumpStrength = character.jumpStrength
	timeJumpApex = character.timeJumpApex
	fallMultiplier = character.fallMultiplier
	dashStrength = character.dashStrength
	aimWeight = character.aimWeight
	bounceOff = character.bounceOff
	graceTime = character.graceTime
	
func disableCollisionBox():
	hitbox.set_deferred("disabled", true)
	
func startGracePeriod():
	gracePeriod.wait_time = character.graceTime
	gracePeriod.start()
	flashing = true
	
	setEnemyCollision(false)
	
func kill():
	var respawner = Objects.spawn(24, global_position)
	
	Globals.player = null
	remove_child(camera)
	respawner.add_child(camera)
	respawner.respawnPos = lastGoodPosition
	queue_free()
	
func _gracePeriodEnd():
	visible = true
	flashing = false
	
	setEnemyCollision(true)
	
func setEnemyCollision(booly: bool):
	set_collision_mask_bit(2, booly)
	set_collision_mask_bit(3, booly)
