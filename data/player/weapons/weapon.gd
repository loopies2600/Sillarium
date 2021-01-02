extends Sprite

export (PackedScene) var projectile
export (Vector2) var projectileOffset = Vector2(0, 0)
export (bool) var hasCooldown = true
export (float) var cooldown = 0
export (int) var rotationSpeed = 0

var rotationTimer = 5.0
var currentCooldown = cooldown
var cooldownIsOver = false
var fireAngle = 0

func _ready():
	if !hasCooldown:
		cooldown = 0
		cooldownIsOver = true
	
func _process(delta):
	offset.x = lerp(offset.x, 0, rotationSpeed * delta)
	setFiringDirection(delta)
	
	if hasCooldown:
		_checkCooldown(delta)
	
func fire(delta):
	offset.x = lerp(offset.x, projectileOffset.y, (rotationSpeed * 2) * delta)
	var newProjectile = projectile.instance()
	newProjectile.global_position = global_position + projectileOffset.rotated(fireAngle) + Vector2(randi() % 9, randi() % 9 -8)
	newProjectile.rotation = fireAngle
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
	
	var LLEFT = Input.is_action_pressed("look_left")
	var LRIGHT = Input.is_action_pressed("look_right")
	var LUP = Input.is_action_pressed("look_up")
	var LDOWN = Input.is_action_pressed("look_down")
	# Pone la direccion correcta
	fireDirection = Vector2(int(LRIGHT) - int(LLEFT), int(LDOWN) - int(LUP))
	
	if LLEFT || LRIGHT || LUP || LDOWN:
		rotationTimer = 5
		fireAngle = lerp_angle(fireAngle, fireDirection.angle(), rotationSpeed * delta)
	
	if Input.is_action_pressed("shoot") and cooldownIsOver:
		rotationTimer = 5
		fire(delta)
	
	if rotationTimer >= 0:
		rotation = fireAngle
	else:
		rotation = lerp_angle(rotation, 0, rotationSpeed * delta)
		fireAngle = rotation
