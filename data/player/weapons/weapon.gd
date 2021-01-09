extends Sprite

export (PackedScene) var projectile

export (Vector2) var projectileOffset = Vector2(0, 0)
export (bool) var hasCooldown = true
export (float) var velocityReduction = 0.0
export (float) var cooldown = 0

var armsPos

var rotationTimer = 5.0
var currentCooldown = cooldown
var cooldownIsOver = false
var fireAngle = 0

func _ready():
	if !hasCooldown:
		cooldown = 0
		cooldownIsOver = true
	
func _process(delta):
	global_position = armsPos.global_position
	offset.x = lerp(offset.x, 0, delta * 4)
	
	if Input.is_action_pressed("shoot") and cooldownIsOver:
		if velocityReduction != 0.0:
			Globals.get("player").maxSpeed = 300.0 - velocityReduction
			
		rotationTimer = 5
		fire(delta)
		
	if Input.is_action_just_released("shoot") and cooldownIsOver:
		if velocityReduction != 0.0:
			Globals.get("player").maxSpeed = 300.0
		
	if hasCooldown:
		_checkCooldown(delta)
	
func fire(delta):
	offset.x = lerp(offset.x, projectileOffset.y, delta * 8)
	var newProjectile = projectile.instance()
	newProjectile.global_position = global_position + projectileOffset.rotated(fireAngle) + Vector2(randi() % 9, randi() % 9 -8)
	newProjectile.global_rotation = fireAngle
	newProjectile.z_index = z_index + 1
	get_tree().get_root().add_child(newProjectile)
	currentCooldown = cooldown
	
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
		rotation = lerp_angle(rotation, 0, delta * 4)
		fireAngle = rotation
