extends "res://scenes/enemy/BasicEnemyController.gd"

onready var animPlayer = $Graphics/AnimationPlayer
onready var shotStartPos = $BulletStartPosition
onready var fireTimer = $ShootTimer

export (PackedScene) var projectile
export (float) var speed = 50
export (float) var firingTime = 3

var currentSpeed

func _ready():
	fireTimer.connect("timeout", self, "OnFireTimerTimeout")
	animPlayer.play("Slithering")
	fireTimer.wait_time = firingTime
	fireTimer.start()
	currentSpeed = speed

func _physics_process(delta):
	position.x += speed * delta

func PlaySlitherAnim():
	currentSpeed = speed
	animPlayer.play("Slithering")

func OnFireTimerTimeout():
	currentSpeed = 0
	animPlayer.play("Firing")

func Fire():
	var newShot = projectile.instance()
	newShot.position = shotStartPos.global_position
	newShot.rotation = rotation
	get_tree().get_root().add_child(newShot)
