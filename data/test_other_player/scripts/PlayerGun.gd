extends Node2D

onready var sprite = $Sprite
onready var cooldownTimer = $Timer
onready var bulletStartPos = $BulletStartPos

export (PackedScene) var bullet
export (float) var cooldown = 0.3
export (Array, StreamTexture) var aimTextures

var anglePerDirection = TAU / 8

func _ready():
	cooldownTimer.wait_time = cooldown

func RotateTo(angle):
	rotation = angle

func ChangeSprite(playerFlipped):
	sprite.flip_v = false

	# Consigue el indice del angulo
	var angleStep = stepify(global_rotation, anglePerDirection)
	angleStep = fposmod(angleStep, TAU)
	var spriteIndex = int(angleStep / anglePerDirection)

	sprite.texture = aimTextures[spriteIndex]

	# Espeja el sprite de arriba/abajo dependiendo en la direccion
	if spriteIndex == 2 or spriteIndex == 6:
		if playerFlipped:
			sprite.flip_v = true

func Fire():
	if cooldownTimer.time_left == 0:

		# Crea la bala y le da velocidad
		var newBullet = bullet.instance()
		newBullet.global_position = bulletStartPos.global_position
		newBullet.global_rotation = rotation
		#newBullet.speed = Vector2(1000, 0)
		get_tree().get_root().add_child(newBullet)

		cooldownTimer.start()
