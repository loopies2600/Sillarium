extends Kinematos
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
onready var bounceOff = character.bounceOff
onready var graceTime = character.graceTime

var lastGoodPosition := Vector2()

var isGrounded := true
var jumpForce
var snapVector = Vector2(0.0, Globals.MAX_FLOOR_ANGLE)
var velocity := Vector2()

var currentDamage := 0
var currentBump := 0.0

var canInput := false
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
	
	Globals.weapon = Objects.getWeapon(0, armsPos, z_index + 1, self)
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
	
func _process(_delta):
	handleWeaponInput()
	flashBehaviour()
	
	match getInputDirection():
		-1:
			FlipGraphics(true)
		1:
			FlipGraphics(false)
	
func _physics_process(delta):
	keepOnScreen()
	groundCheck()
	
	var gravity
	gravity = (2 * jumpStrength) / pow(timeJumpApex, 2)
	
	jumpForce = gravity * timeJumpApex
	velocity.y += gravity * delta * (fallMultiplier if velocity.y > 0 else 1)
	
	velocity.y = move_and_slide_with_snap(velocity, snapVector, Globals.UP, true).y
	
func keepOnScreen():
	var ctrans = get_canvas_transform()

	var minPos = -ctrans.get_origin() / ctrans.get_scale()

	var viewSize = get_viewport_rect().size / ctrans.get_scale()
	var maxPos = minPos + viewSize

	global_position.x = clamp(global_position.x, minPos.x, maxPos.x)

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
	
func animspeedAsVelocity():
	if getInputDirection():
		animator.playback_speed = velocity.x / maxSpeed
	else:
		animator.playback_speed = 1
	
func playRandomAnim(anims : Array):
	randomize()
	var animToPlay = randi() % anims.size()
	animator.play(anims[animToPlay])
	
func move(speed := maxSpeed, direction := getInputDirection()):
	velocity.x = clamp(velocity.x + (getInputDirection() * speed), -speed, speed)
	
func damp(damping := friction):
	velocity.x *= damping
	
func flashBehaviour():
	if flashing:
		visible = !visible
	
func getInputDirection() -> int:
	if canInput:
		var inputDirection = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		return inputDirection
	else: return 0
	
func getFacingDirection(returnFlipState = false):
	var facingDirection = -1 if body.flip_h else 1
	
	if returnFlipState:
		return body.flip_h
		
	return facingDirection
	
func handleWeaponInput():
	if canInput:
		currentWeapon.set_process(true)
		currentWeapon.set_process_input(true)
	else:
		currentWeapon.set_process(false)
		currentWeapon.set_process_input(false)

func FlipGraphics(flip):
	for part in bodyParts:
		part.flip_h = flip
	
func takeDamage(damage, bump = maxSpeed * -1 if body.flip_h else maxSpeed * 1):
	currentDamage = damage
	currentBump = bump
	emit_signal("player_damaged")
	
func disableCollisionBox():
	hitbox.set_deferred("disabled", true)
	
func startGracePeriod():
	gracePeriod.wait_time = character.graceTime
	gracePeriod.start()
	flashing = true
	
	setCollisionBits([2, 3], false)
	
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
	
	setCollisionBits([2, 3], true)
