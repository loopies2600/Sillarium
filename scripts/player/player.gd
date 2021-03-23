extends Kinematos
class_name Player, "res://sprites/ui/menu/player.png"

signal player_grounded_updated(isGrounded)
signal player_damaged(x, y)
signal player_health_updated(health)
signal player_killed()
signal player_respawned()
signal player_score_updated

export(Resource) var character
onready var dashTexture = character.dashTexture

onready var health = character.health setget _setHealth
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

var canInput := false
var flashing := false
var canDash := true

var score := 0 setget _setScore
var deaths := 0 setget _setDeaths

var playerID = 0

onready var stateMachine = $StateMachine
onready var graphics = $Graphics
onready var animator = $Graphics/PlayerAnimator
onready var graphicsAnimator = $GraphicsAnimator
onready var armsPos = $ArmsPosition
onready var body = $Graphics/Body
onready var head = $Graphics/Body/Head
onready var legs = $Graphics/Body/Legs
onready var hitbox = $CollisionShape2D
onready var camera = $Camera
onready var attackSound = $FiringSound
onready var gracePeriod = $GracePeriodTimer

onready var bodyParts = [head, body, legs]

onready var currentWeapon

func _ready():
	Globals.weapon = Objects.getWeapon(0, armsPos, z_index + 1, self)
	currentWeapon = Globals.weapon
	add_child(currentWeapon)
	
func connectSignals():
	Objects.currentWorld.connect("level_initialized", self, "_onLevelInit")
	Objects.currentWorld.connect("level_started", self, "_onLevelStart")
	gracePeriod.connect("timeout", self, "_gracePeriodEnd")
	camera.connectToManipulators()
	connect("player_respawned", self, "_onRespawn")
	
	stateMachine.connectSignals()
	
func _onLevelInit():
	canInput = false
	
func _onLevelStart():
	startGracePeriod()
	canInput = true
	
func _onRespawn():
	startGracePeriod()
	canInput = true
	velocity = Vector2.ZERO
	velocity.y -= jumpStrength / 4
	
func _process(_delta):
	if getInputDirection():
		flipGraphics(getInputDirection())
		
	handleInputProcessing()
	flashBehaviour()
	
func _physics_process(delta):
	keepOnScreen(true)
	print(canInput)
	groundCheck()
	
	var gravity
	gravity = (2 * jumpStrength) / pow(timeJumpApex, 2)
	
	jumpForce = gravity * timeJumpApex
	velocity.y += gravity * delta * (fallMultiplier if velocity.y > 0 else 1)
	
	velocity.y = move_and_slide_with_snap(velocity, snapVector, Globals.UP, true).y
	
func _setScore(value : int) -> void:
	score = value
	emit_signal("player_score_updated")
	
func _setDeaths(value : int) -> void:
	deaths = value
	emit_signal("player_killed")
	
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
	
func animateGraphics(anim : String):
	graphicsAnimator.stop()
	graphicsAnimator.play(anim)
	graphicsAnimator.queue("default")
	
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
	
func getFacingDirection():
	var facingDirection = body.scale.x
	return facingDirection
	
func handleInputProcessing():
	currentWeapon.set_process(canInput)
	currentWeapon.set_process_input(canInput)

func flipGraphics(facing):
	body.scale.x = facing
	
func takeDamage(damage, bumpX = (-maxSpeed * 2) * getFacingDirection(), bumpY = (-jumpStrength * 4)):
	if !flashing:
		startGracePeriod()
		animateGraphics("hurt")
		self.health -= damage
		emit_signal("player_damaged", bumpX, bumpY)
	
func disableCollisionBox():
	hitbox.set_deferred("disabled", true)
	
func startGracePeriod():
	gracePeriod.wait_time = character.graceTime
	gracePeriod.start()
	flashing = true
	
	setCollisionBits([2, 3], false)
	
func _setHealth(value: int):
	var prevHealth = health
	health = clamp(value, 0, character.health)
	
	if health != prevHealth:
		emit_signal("player_health_updated", health)
		
		if health == 0:
			kill()
	
func kill():
	self.deaths += 1
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
