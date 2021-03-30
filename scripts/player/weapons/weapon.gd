extends AnimatedSprite

signal weapon_ammo_updated()

export(Resource) var type

var armsPos

onready var ammo = type.maxAmmo setget _setAmmo
onready var flipXDown = type.projectileOffset[2].x
onready var flipXUp = type.projectileOffset[6].x
onready var cooldownTimer = $Cooldown

var rotationTimer = 5.0
var cooldownIsOver = false

var anglePerDirection = TAU / 8
var angleIndex = 0

onready var muzzleFlash = preload("res://data/player/projectiles/muzzle_flash.tscn")

func _ready():
	if type.hasCooldown:
		_startCooldown()
	else:
		cooldownIsOver = true
	
	play("Idle")
	var _unused = connect("animation_finished", self, "_animEnd")
	cooldownTimer.connect("timeout", self, "_cooldownTimeout")
	
func ChangeSprite(flip):
	flip_v = false

	# Consigue el indice del angulo
	var angleStep = stepify(global_rotation, anglePerDirection)
	angleStep = fposmod(angleStep, TAU)
	angleIndex = int(angleStep / anglePerDirection)

	frames = type.aimGraphics[angleIndex]
	
	if angleIndex == 2 or angleIndex == 6:
		if flip == -1:
			flip_v = true
	
	type.projectileOffset[2].x = -flipXDown if flip else flipXDown
	type.projectileOffset[6].x = -flipXUp if flip else flipXUp
	
func _setAmmo(value : int) -> void:
	ammo = value
	emit_signal("weapon_ammo_updated")
	
func _process(delta):
	if armsPos != null:
		global_position = armsPos.global_position
		
	offset.x = lerp(offset.x, 0, delta * 8)
	
	if type.canRotate:
		doRotation()
		
	_handleFiring()
		
func _handleFiring():
	match type.fireType:
		0:
			if Input.is_action_just_pressed("shoot" + get_parent().inputSuffix) and cooldownIsOver:
				fire()
		1:
			if Input.is_action_pressed("shoot" + get_parent().inputSuffix) and cooldownIsOver:
				fire()
	
func doRotation():
	var direction = Vector2(
		int(Input.is_action_pressed("aim_right" + get_parent().inputSuffix)) - int(Input.is_action_pressed("aim_left" + get_parent().inputSuffix)),
		int(Input.is_action_pressed("aim_down" + get_parent().inputSuffix)) - int(Input.is_action_pressed("aim_up" + get_parent().inputSuffix)))
		
	var desiredRotation
	
	if direction != Vector2.ZERO:
		desiredRotation = direction.angle()
		
	else:
		if get_parent().getFacingDirection() == -1:
			desiredRotation = PI
		else:
			desiredRotation = 0
			
	rotation = lerp_angle(rotation, desiredRotation, type.aimWeight)
	ChangeSprite(get_parent().getFacingDirection())
	
func fire():
	if ammo > 0:
		play("Fire")
		
		if type.displayFlash:
			var newFlash = muzzleFlash.instance()
			newFlash.position = position + type.projectileOffset[angleIndex]
			newFlash.global_rotation = global_rotation
			get_parent().add_child(newFlash)
			
		if type.hasCooldown:
			_startCooldown()
			
		offset.x = 4
		var newProjectile = type.projectile.instance()
		newProjectile.add_to_group("PlayerProjectile")
		newProjectile.global_position = global_position + type.projectileOffset[angleIndex]
		newProjectile.global_rotation = global_rotation
		newProjectile.z_index = z_index - 16
		newProjectile.papa = get_parent()
		get_tree().get_root().add_child(newProjectile)
		get_parent().attackSound.play()
			
		if type.recoil > 0.0:
			get_parent().velocity -= Vector2(type.recoil, 0.0).rotated(global_rotation)
		
		self.ammo -= 1
	
func _startCooldown():
	cooldownIsOver = false
	cooldownTimer.wait_time = type.cooldown
	cooldownTimer.start()
	
func _cooldownTimeout():
	cooldownIsOver = true
	
func _animEnd():
	pass
