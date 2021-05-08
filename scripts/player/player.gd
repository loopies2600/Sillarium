extends Kinematos
class_name Player, "res://sprites/ui/menu/player.png"

signal player_damaged(x, y)
signal player_combo_updated()
signal player_health_updated(health)
signal player_lives_updated()
signal player_score_updated()
signal player_weapon_updated(wpsID)
signal player_killed()
# warning-ignore:unused_signal
signal player_respawned()

export(Resource) var character

onready var armsTextures = character.armsTextures
onready var health = character.health setget _setHealth
onready var airMaxSpeed = character.airMaxSpeed
onready var airFriction = character.airFriction
onready var dashStrength = character.dashStrength
onready var dashDuration = character.dashDuration
onready var bounciness = character.bounciness
onready var graceTime = character.graceTime
onready var comboTime = character.comboTime
onready var respawnTime = character.respawnTime

var playerID := 0
var slot := "player"

var canDash := true
var trackInput := true setget _setTrackInput
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
onready var graphicsAnimator = $GraphicsAnimator
onready var feetPos = $FeetPosition
onready var body = $Graphics/Body
onready var head = $Graphics/Body/Head
onready var legs = $Graphics/Body/Legs
onready var hitbox = $CollisionShape2D
onready var camera = $Camera
onready var gracePeriod = $Timers/GracePeriodTimer
onready var comboPeriod = $Timers/ComboTimer
onready var shadow = $Shadow
onready var arms = [$Graphics/Body/RightArm, $Graphics/Body/LeftArm]
onready var bodyParts = [head, body, legs]

var stretchableArms := []

func _ready():
	animator = $Graphics/PlayerAnimator
	mainSprite = body
	setupProperties(character, 8)
	
	weapon = Objects.getWeapon(0, self, z_index + 1)
	currentWeapon = weapon
	add_child(currentWeapon)
	
	for a in arms.size():
		var targetZ = [256, 0]
		var newArm = Objects.getObj(28)
		newArm.startPos = arms[a].global_position
		newArm.sprite = armsTextures[a]
		newArm.z_index =  targetZ[a]
		newArm.set_as_toplevel(true)
		stretchableArms.append(newArm)
		arms[a].add_child(newArm)
	
func connectSignals():
	var _unused = gracePeriod.connect("timeout", self, "_gracePeriodEnd")
	_unused = comboPeriod.connect("timeout", self, "_comboEnd")
	_unused = camera.connectToManipulators()
	
func _onLevelReady():
	connectSignals()
	canInput = false
	
func _onLevelStart():
	Objects.spawn(16)
	startGracePeriod()
	canInput = true
	
func _process(_delta):
	_repositionArms()
	keepOnScreen(true, false, Vector2(hitbox.shape.extents.x * 2, 0))
	
	handleInputProcessing()
	flashBehaviour()
	
func _repositionArms():
	for a in stretchableArms.size():
		stretchableArms[a].startPos = arms[a].global_position
		stretchableArms[a].endPos = weapon.hands[a].global_position
		
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
	
func flashBehaviour():
	if flashing:
		for arm in stretchableArms:
			arm.visible = Renderer.flicker
			
		visible = Renderer.flicker
		
	if !doinCombo && combo > 0:
		combo -= 1
		emit_signal("player_combo_updated")
		self.score += 1
	
func handleInputProcessing():
	currentWeapon.set_process(canInput)
	currentWeapon.set_process_input(canInput)
	
func takeDamage(damage, bumpAnyways := false, bumpX = (-maxSpeed * 2) * getFacingDirection(), bumpY = (-jumpStrength * 4)):
	if bumpAnyways:
		emit_signal("camera_shake_requested")
		emit_signal("player_damaged", bumpX, bumpY, false)
		
	if !flashing:
		emit_signal("camera_shake_requested")
		startGracePeriod()
		animateGraphics("hurt")
		self.health -= damage
		emit_signal("player_damaged", bumpX, bumpY, true if health <= 0 else false)
	
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
	
func _gracePeriodEnd():
	for arm in stretchableArms:
		arm.visible = true
		
	visible = true
	flashing = false
	
	setCollisionBits([CollisionLayers.ENEMY, CollisionLayers.ENEMY_PROJECTILE], true)
	
func _comboEnd():
	doinCombo = false
