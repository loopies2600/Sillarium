extends KinematicBody2D

onready var animPlayer = $Area2D/Graphics/AnimationPlayer
onready var shotStartPos = $BulletStartPosition
onready var fireTimer = $ShootTimer

export (PackedScene) var projectile
export (float) var speed = 50
export (float) var firingTime = 3
export (float) var gravityStrength = 50
export (Vector2) var gravityDirection = Vector2.DOWN

var velocity = Vector2()
var moving = true

func _ready():
	fireTimer.connect("timeout", self, "OnFireTimerTimeout")
	animPlayer.play("Slithering")
	fireTimer.wait_time = firingTime
	fireTimer.start()

func _physics_process(delta):
	HandleMovement(delta)

func HandleMovement(delta):
	var touchingSurface = false
	
	if is_on_wall():
		rotation = PI * 3 / 2
		velocity = Vector2(gravityStrength, -speed)
		touchingSurface = true
	elif is_on_floor():
		rotation = 0
		velocity = Vector2(speed, gravityStrength)
		touchingSurface = true
	if is_on_ceiling():
		rotation = PI
		velocity = Vector2(-speed, -gravityStrength)
		touchingSurface = true
	
	if !touchingSurface:
		velocity.y += gravityStrength * delta
	
	if moving:
		velocity = move_and_slide(velocity, Vector2.UP)

func AdjustToFloor():
	rotation = 0
	velocity = Vector2(speed, gravityStrength)

func AdjustToWall():
	rotation = PI*3/2
	velocity = Vector2(gravityStrength, -speed)

func AdjustToCeiling():
	rotation = PI * 2
	velocity = Vector2(-speed, -gravityStrength)

func PlaySlitherAnim():
	moving = true
	animPlayer.play("Slithering")

func OnFireTimerTimeout():
	moving = false
	animPlayer.play("Firing")

func Fire():
	var newShot = projectile.instance()
	newShot.position = shotStartPos.global_position
	newShot.rotation = rotation
	get_tree().get_root().add_child(newShot)
