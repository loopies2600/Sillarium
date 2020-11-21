extends KinematicBody2D

# Node variables
onready var animPlayer = $Area2D/Graphics/AnimationPlayer
onready var shotStartPos = $BulletStartPosition
onready var fireTimer = $ShootTimer
onready var graphics = $Area2D/Graphics

# Exported variables
export (PackedScene) var projectile
export (float) var speed = 50
export (float) var firingTime = 3
export (float) var gravityStrength = 1000

# Movement variables
var velocity = Vector2()
var moving = true
var touchingSurface = false

func _ready():
	# Connecting nodes
	fireTimer.connect("timeout", self, "OnFireTimerTimeout")
	animPlayer.play("Slithering")
	# Initializing timer
	fireTimer.wait_time = firingTime
	fireTimer.start()

func _physics_process(delta):
	HandleMovement(delta)

func HandleMovement(delta):
	
	if is_on_floor():
		ClingToFloor()
	if is_on_wall():
		ClingToWall()
	
	if !touchingSurface:
		velocity.y = gravityStrength
	
	if moving:
		velocity = move_and_slide(velocity, Vector2.UP, false, 32, PI)

func ClingToFloor():
	touchingSurface = true
	velocity = Vector2(speed, gravityStrength)

func ClingToWall():
	touchingSurface = true
	# Get space state
	var spaceState = get_world_2d().direct_space_state
	# Check if wall is to the right
	var result = spaceState.intersect_ray(position, position + Vector2(25, 0), [self], collision_mask, true, false)
	if result:
		# Wall to the right
		velocity = Vector2(gravityStrength, -speed)
		if is_on_ceiling():
			ClingToCeiling()
	else:
		# Wall to the left
		velocity.y = Vector2(-gravityStrength, speed)
		if is_on_floor():
			ClingToFloor()

func ClingToCeiling():
	# Ceiling
	touchingSurface = true
	velocity = Vector2(-speed, -gravityStrength)

func PlaySlitherAnim():
	# Plays slither animation
	moving = true
	animPlayer.play("Slithering")

func OnFireTimerTimeout():
	# Plays firing animation twice if it's on a floor
	if is_on_floor():
		moving = false
		animPlayer.play("FiringTwice")
	else:
		moving = false
		animPlayer.play("Firing")

func Fire(speed_x, speed_y):
	# Creates projectile
	var newShot = projectile.instance()
	newShot.position = shotStartPos.global_position
	newShot.speed = Vector2(speed_x, speed_y)
	newShot.rotation = rotation
	get_tree().get_root().add_child(newShot)
