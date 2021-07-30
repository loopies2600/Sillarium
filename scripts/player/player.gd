extends Kinematos
class_name Player, "res://sprites/ui/menu/player.png"

signal player_damaged(bump, letal)
signal player_combo_updated()
signal player_health_updated(health)
signal player_lives_updated()
signal player_score_updated()
signal player_weapon_updated(wpsID)
signal player_killed()
signal player_respawned()

export(Resource) var character

onready var armsTextures = character.armsTextures
onready var health = character.health setget _setHealth
onready var airMaxSpeed = character.airMaxSpeed
onready var airDeceleration = character.airDeceleration
onready var dashStrength = character.dashStrength
onready var jumpCut = character.jumpCut
onready var graceTime = character.graceTime
onready var comboTime = character.comboTime
onready var respawnTime = character.respawnTime

var charID := 0
var playerID := 0
var slot := "player"
var children := []

var canDash := true
var trackInput := true setget _setTrackInput
var doinCombo := false
var doinJump := false

var combo := 0 setget _setCombo
var deaths : int = Data.getData(slot, "deaths") setget _setDeaths
var lives : int = Data.getData(slot, "lives") setget _setLives
var score : int = Data.getData(slot, "total_score") setget _setScore

var currentWeapon
var weapon

onready var stateMachine = $StateMachine
onready var graphics = $Graphics
onready var graphicsAnimator = $GraphicsAnimator
onready var feetPos = $FeetPosition
onready var camera = $Camera
onready var gracePeriod = $Timers/GracePeriodTimer
onready var comboPeriod = $Timers/ComboTimer
onready var coyotePeriod = $Timers/CoyoteTimer
onready var shadow = $Shadow
onready var bodyParts = [$Graphics/Body/Head, $Graphics/Body, $Graphics/Body/Legs]
onready var arms = [$Graphics/Body/LeftArm, $Graphics/Body/RightArm]

func _ready():
	setupProperties(character, 8)
	pickUpWeapon(0)
	
func connectSignals():
	var _unused = gracePeriod.connect("timeout", self, "_endGracePeriod")
	_unused = comboPeriod.connect("timeout", self, "_comboEnd")
	_unused = camera.connectToManipulators()
	
func _onLevelReady():
	connectSignals()
	self.canInput = false
	
func _onLevelStart():
	Objects.spawn(16)
	startGracePeriod()
	self.canInput = true
	
func _setScore(value : int) -> void:
	score = value
	Data.setData(slot, "total_score", score)
	emit_signal("player_score_updated")
	
func _setDeaths(value : int) -> void:
	deaths = value
	Data.setData(slot, "deaths", deaths)
	emit_signal("player_killed")
	
func _setLives(value : int) -> void:
	lives = value
	Data.setData(slot, "lives", lives)
	emit_signal("player_lives_updated")
	
func _setCombo(value : int) -> void:
	# warning-ignore:narrowing_conversion
	if doinCombo:
		combo = clamp(value, 0, 1000000)
	else:
		womboCombo()
		
	emit_signal("player_combo_updated")
	
func pickUpWeapon(id):
	emit_signal("player_weapon_updated", id)
	if currentWeapon != null:
		currentWeapon.queue_free()
		
	weapon = Objects.getWeapon(id, self, z_index + 1)
	currentWeapon = weapon
	add_child(currentWeapon)
	
func animateGraphics(anim : String):
	graphicsAnimator.stop()
	graphicsAnimator.play(anim)
	graphicsAnimator.queue("default")
	
func loop():
	if flashing:
		visible = Renderer.flicker
	else:
		visible = true
		
	if !doinCombo && combo > 0:
			combo -= 1
			emit_signal("player_combo_updated")
			self.score += 1
		
	trails(bodyParts, Settings.getSetting("dont-autogenerate-buttons", "accent_color_" + str(charID)))
	keepOnScreen(true, false, Vector2(collisionBox.shape.extents.x * 2, 0))
	
func mainMotion(_delta):
	canDash = !is_on_floor()
	if !is_on_floor(): stateMachine._change_state("air")
	
	var wasGrounded = is_on_floor()
	velocity.y = move_and_slide_with_snap(velocity, snapVector, Globals.UP).y
	
	if !is_on_floor() && wasGrounded && !doinJump:
		coyotePeriod.start()
	
func move(speed := maxSpeed, direction := getInputDirection()):
	velocity.x = speed * direction
	
func _input(event):
	if canInput:
		if event.is_action_pressed("jump" + inputSuffix):
			if is_on_floor() || !coyotePeriod.is_stopped():
				coyotePeriod.stop()
				stateMachine._change_state("air", {isJump = true})
				
		if canDash:
			if event.is_action_pressed("dash" + inputSuffix):
				stateMachine._change_state("dash")
		
func _setInput(booly : bool):
	canInput = booly
	currentWeapon.set_process(canInput)
	currentWeapon.set_process_input(canInput)
	
func takeDamage(damage, bump = Vector2((-maxSpeed * 2) * getFacingDirection(), (-jumpStrength * 4)), stunTime := 0.075):
	setProcessing(false)
	yield(get_tree().create_timer(stunTime), "timeout")
	setProcessing(true)
	
	if !flashing:
		var deadly = damage >= health
		emit_signal("camera_shake_requested")
		startGracePeriod()
		animateGraphics("hurt")
		self.health -= damage
		stateMachine._change_state("bump", {"bump" : bump, "isDeadly" : deadly})
		emit_signal("player_damaged")
	
func startGracePeriod():
	gracePeriod.wait_time = character.graceTime
	gracePeriod.start()
	self.flashing = true
	
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
		
		if health < 0:
			kill()
	
func _setTrackInput(booly : bool):
	if trackInput == booly:
		return
		
	trackInput = booly
	
	Settings.bindKeys(!trackInput)
		
func kill():
	self.trackInput = false
	
	setCollisionBits([CollisionLayers.ENEMY, CollisionLayers.ENEMY_PROJECTILE], false)
	
	if lives > 0:
		_respawn()
	
func _respawn():
	yield(get_tree().create_timer(respawnTime), "timeout")
	self.health = character.health
	setCollisionBits([CollisionLayers.ENEMY, CollisionLayers.ENEMY_PROJECTILE], true)
	self.deaths += 1
	self.lives -= 1
	position = lastGoodPosition
	self.trackInput = true
	emit_signal("player_respawned")
	startGracePeriod()
	
func _endGracePeriod():
	self.flashing = false
	
	setCollisionBits([CollisionLayers.ENEMY, CollisionLayers.ENEMY_PROJECTILE], true)
	
func _comboEnd():
	doinCombo = false
