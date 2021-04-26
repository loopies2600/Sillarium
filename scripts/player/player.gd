extends Kinematos
class_name Player, "res://sprites/ui/menu/player.png"

signal player_grounded_updated(isGrounded)
signal player_damaged(x, y)
signal player_combo_updated()
signal player_gravity_updated(doinGravity)
signal player_health_updated(health)
signal player_lives_updated()
signal player_score_updated()
signal player_weapon_updated(wpsID)
signal player_killed()
# warning-ignore:unused_signal
signal player_respawned()

export(Resource) var character

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
onready var bounciness = character.bounciness
onready var graceTime = character.graceTime
onready var comboTime = character.comboTime

var playerID := 0
var slot := "player"
var inputSuffix := ""
var lastGoodPosition := Vector2()

var isGrounded := true
var jumpForce
var snapVector = Vector2(0.0, Globals.MAX_FLOOR_ANGLE)

var applyGravity := true setget _doGravity
var canDash := true
var canInput := false
var dragging := false
var doinCombo := false
var flashing := false

var combo := 0 setget _setCombo
var deaths : int = Data.getData(slot, "deaths") setget _setDeaths
var lives : int = Data.getData(slot, "lives") setget _setLives
var score : int = Data.getData(slot, "total_score") setget _setScore

var currentWeapon
var weapon

onready var stateMachine = $StateMachine
onready var graphics = $Graphics
onready var animator = $Graphics/PlayerAnimator
onready var graphicsAnimator = $GraphicsAnimator
onready var armsPos = $ArmsPosition
onready var feetPos = $FeetPosition
onready var body = $Graphics/Body
onready var head = $Graphics/Body/Head
onready var legs = $Graphics/Body/Legs
onready var hitbox = $CollisionShape2D
onready var camera = $Camera
onready var gracePeriod = $Timers/GracePeriodTimer
onready var comboPeriod = $Timers/ComboTimer
onready var shadow = $Shadow

onready var bodyParts = [head, body, legs]

func _ready():
	shadow.set_as_toplevel(true)
	weapon = Objects.getWeapon(0, armsPos, z_index + 1, self)
	currentWeapon = weapon
	add_child(currentWeapon)
	
func connectSignals():
	var _unused = Objects.currentWorld.connect("level_initialized", self, "_onLevelInit")
	_unused = Objects.currentWorld.connect("level_started", self, "_onLevelStart")
	_unused = gracePeriod.connect("timeout", self, "_gracePeriodEnd")
	_unused = comboPeriod.connect("timeout", self, "_comboEnd")
	_unused = camera.connectToManipulators()
	_unused = connect("player_respawned", self, "_onRespawn")
	
	stateMachine.connectSignals()
	
func _onLevelInit():
	canInput = false
	
func _onLevelStart():
	Objects.spawn(16)
	startGracePeriod()
	canInput = true
	
func _onRespawn():
	startGracePeriod()
	canInput = true
	velocity = Vector2.ZERO
	velocity.y -= jumpStrength / 4
	
func _process(_delta):
	if dragging:
		snapVector = Vector2.ZERO
		var newPos = get_global_mouse_position()
		velocity = (newPos - position) * 4
	else:
		keepOnScreen(true, false, Vector2(hitbox.shape.extents.x * 2, 0))
		
	if getInputDirection():
		flipGraphics(getInputDirection())
		
	handleInputProcessing()
	flashBehaviour()
	
func _physics_process(delta):
	groundCheck()
	
	var gravity
	gravity = (2 * jumpStrength) / pow(timeJumpApex, 2)
	
	jumpForce = gravity * timeJumpApex
	
	if applyGravity:
		if !dragging:
			velocity.y += gravity * delta * (fallMultiplier if velocity.y > 0 else 1)
	
	velocity.y = move_and_slide_with_snap(velocity, snapVector, Globals.UP, true).y
	
func _doGravity(booly : bool) -> void:
	applyGravity = booly
	emit_signal("player_gravity_updated", applyGravity)
	
func _setScore(value : int) -> void:
	Data.setData(slot, "total_score", value)
	score = Data.getData(slot, "total_score")
	emit_signal("player_score_updated")
	
func _setDeaths(value : int) -> void:
	Data.setData(slot, "deaths", value)
	deaths = Data.getData(slot, "deaths")
	emit_signal("player_killed")
	
func _setLives(value : int) -> void:
	Data.setData(slot, "lives", value)
	lives = Data.getData(slot, "lives")
	emit_signal("player_lives_updated")
	
func _setCombo(value : int) -> void:
# warning-ignore:narrowing_conversion
	if doinCombo:
		combo = clamp(value, 0, 1000000)
	else:
		womboCombo()
		
	emit_signal("player_combo_updated")
	
func groundCheck():
	var wasGrounded = isGrounded
	isGrounded = is_on_floor()
	
	if wasGrounded == null || isGrounded != wasGrounded:
		emit_signal("player_grounded_updated", isGrounded)
		lastGoodPosition = position
		
func pickUpWeapon(id):
	emit_signal("player_weapon_updated", id)
	if currentWeapon != null:
		currentWeapon.queue_free()
		
	weapon = Objects.getWeapon(id, armsPos, z_index + 1)
	currentWeapon = weapon
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
	velocity.x = clamp(velocity.x + (acceleration * direction), -speed, speed)
	
func damp(damping := friction):
	velocity.x *= damping
	
func flashBehaviour():
	if flashing:
		visible = !visible
		
	if !doinCombo && combo > 0:
		combo -= 1
		emit_signal("player_combo_updated")
		self.score += 1
	
func getInputDirection() -> int:
	if canInput:
		var inputDirection = Input.get_action_strength("move_right" + inputSuffix) - Input.get_action_strength("move_left" + inputSuffix)
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
		emit_signal("camera_shake_requested")
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
	
	setCollisionBits([CollisionLayers.ENEMY, CollisionLayers.ENEMY_PROJECTILE], false)
	
func womboCombo():
	comboPeriod.wait_time = character.comboTime
	comboPeriod.start()
	doinCombo = true
	
func _setHealth(value: int):
	var prevHealth = health
	health = clamp(value, 0, character.health)
	
	if health != prevHealth:
		emit_signal("player_health_updated", health)
		
		if health == 0:
			kill()
	
func kill():
	self.deaths += 1
	self.lives -= 1
	
	if lives > 0:
		var respawner = Objects.spawn(24, {
		"global_position" : global_position,
		"respawnPos" : lastGoodPosition, 
		"playerSlot" : slot}
		)
		
		Globals.set(slot, null)
		remove_child(camera)
		respawner.add_child(camera)
		
	queue_free()
	
func _gracePeriodEnd():
	visible = true
	flashing = false
	
	setCollisionBits([CollisionLayers.ENEMY, CollisionLayers.ENEMY_PROJECTILE], true)
	
func _comboEnd():
	doinCombo = false
	
func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			dragging = event.pressed
			
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			dragging = false
