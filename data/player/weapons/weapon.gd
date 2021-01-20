extends Sprite

export(Resource) var type

var armsPos

var rotationTimer = 5.0
onready var currentCooldown = type.cooldown
var cooldownIsOver = false
var fireAngle = 0

onready var muzzleFlash = preload("res://data/player/projectiles/muzzle_flash.tscn")

func _ready():
	texture = type.texture
	
	if !type.hasCooldown:
		type.cooldown = 0
		type.cooldownIsOver = true
	
func _process(delta):
	global_position = armsPos.global_position
	offset.x = lerp(offset.x, 0, delta * 8)
	
	if Input.is_action_pressed("shoot") and cooldownIsOver:
		if type.velocityReduction != 0.0:
			Globals.get("player").maxSpeed = 300.0 - type.velocityReduction
			
		rotationTimer = 5
		fire(delta)
		
	if Input.is_action_just_released("shoot") and cooldownIsOver:
		if type.velocityReduction != 0.0:
			Globals.get("player").maxSpeed = 300.0
		
	if type.hasCooldown:
		_checkCooldown(delta)
		
func fire(delta):
	if type.displayFlash:
		var newFlash = muzzleFlash.instance()
		newFlash.global_position = global_position + type.muzzleOffset.rotated(fireAngle)
		get_tree().get_root().add_child(newFlash)
		
	offset.x = lerp(offset.x, type.projectileOffset.y, delta * 8)
	var newProjectile = type.projectile.instance()
	newProjectile.global_position = global_position + type.projectileOffset.rotated(fireAngle)
	newProjectile.global_rotation = fireAngle
	newProjectile.z_index = z_index
	get_tree().get_root().add_child(newProjectile)
	currentCooldown = type.cooldown
		
	if type.recoil > 0.0:
		Globals.player.velocity -= Vector2(type.recoil, 0.0).rotated(fireAngle)
	
func _checkCooldown(delta):
	if currentCooldown >= 0:
		cooldownIsOver = false
		currentCooldown -= delta
	else:
		cooldownIsOver = true
	
func setFiringDirection(delta):
	rotationTimer -= delta
	var fireDirection = Vector2()
	
	var ALEFT = Input.get_action_strength("aim_left")
	var ARIGHT = Input.get_action_strength("aim_right")
	var AUP = Input.get_action_strength("aim_up")
	var ADOWN = Input.get_action_strength("aim_down")
	
	fireDirection = Vector2(ARIGHT - ALEFT, ADOWN - AUP).normalized()
	
	if ALEFT || ARIGHT || AUP || ADOWN:
		rotationTimer = 5
		fireAngle = fireDirection.angle()
		
	if rotationTimer >= 0:
		rotation = fireAngle
	else:
		rotation = lerp_angle(rotation, 0, delta * 8)
		fireAngle = rotation
