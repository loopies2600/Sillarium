extends Sprite

export(Resource) var type

var armsPos

onready var flipXDown = type.projectileOffset[2].x
onready var flipXUp = type.projectileOffset[6].x

onready var currentCooldown = type.cooldown

var rotationTimer = 5.0
var cooldownIsOver = false

var anglePerDirection = TAU / 8
var angleIndex = 0

onready var muzzleFlash = preload("res://data/player/projectiles/muzzle_flash.tscn")

func _ready():
	if !type.hasCooldown:
		type.cooldown = 0
		type.cooldownIsOver = true
	
func RotateTo(angle):
	rotation = angle

func ChangeSprite(playerFlipped):
	flip_v = false

	# Consigue el indice del angulo
	var angleStep = stepify(global_rotation, anglePerDirection)
	angleStep = fposmod(angleStep, TAU)
	angleIndex = int(angleStep / anglePerDirection)

	texture = type.aimTextures[angleIndex]
	Globals.player.head.texture = Globals.player.headTextures[angleIndex]

	if angleIndex == 2 or angleIndex == 6:
		if playerFlipped:
			flip_v = true
			
	type.projectileOffset[2].x = -flipXDown if playerFlipped else flipXDown
	type.projectileOffset[6].x = -flipXUp if playerFlipped else flipXUp
	
func _process(delta):
	global_position = armsPos.global_position
	offset.x = lerp(offset.x, 0, delta * 8)
	
	if Input.is_action_pressed("shoot") and cooldownIsOver:
		if type.velocityReduction != 0.0:
			Globals.get("player").maxSpeed = Globals.get("player").character.maxSpeed - type.velocityReduction
		fire(delta)
		
	if Input.is_action_just_released("shoot") and cooldownIsOver:
		if type.velocityReduction != 0.0:
			Globals.get("player").maxSpeed = Globals.get("player").character.maxSpeed
		
	if type.hasCooldown:
		_checkCooldown(delta)
		
func fire(delta):
	if type.displayFlash:
		var newFlash = muzzleFlash.instance()
		newFlash.position = position + type.projectileOffset[angleIndex]
		get_parent().add_child(newFlash)
		
	offset.x = lerp(offset.x, 32, delta * 8)
	var newProjectile = type.projectile.instance()
	newProjectile.global_position = global_position + type.projectileOffset[angleIndex]
	newProjectile.global_rotation = global_rotation
	newProjectile.z_index = z_index
	get_tree().get_root().add_child(newProjectile)
	currentCooldown = type.cooldown
		
	if type.recoil > 0.0:
		Globals.player.velocity -= Vector2(type.recoil, 0.0).rotated(global_rotation)
	
func _checkCooldown(delta):
	if currentCooldown >= 0:
		cooldownIsOver = false
		currentCooldown -= delta
	else:
		cooldownIsOver = true
