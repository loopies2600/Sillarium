extends "../behaviour/basic_enemy_controller.gd"

# Node variables
onready var animPlayer = $Graphics/AnimationPlayer
onready var shotStartPos = $BulletStartPosition
onready var fireTimer = $ShootTimer
onready var graphics = $Graphics

# Exported variables
export (PackedScene) var projectile
export (float) var speed = 350
export (float) var firingTime = 3
export (float) var gravityStrength = 1000

# Movement variables
var velocity = Vector2()
var moving = true
var touchingSurface = false
var sRotation = 0

func _ready():
	hitbox = $Area2D
	fireTimer.connect("timeout", self, "OnFireTimerTimeout")
	animPlayer.play("Slithering")
	# Initializing timer
	fireTimer.wait_time = firingTime
	fireTimer.start()

func _physics_process(delta):
	HandleMovement(delta)

func HandleMovement(_delta):
	rotation = lerp_angle(rotation, deg2rad(sRotation), 0.125)
	
	if is_on_floor():
		ClingToFloor()
	if is_on_wall():
		ClingToWall()
	
	if !touchingSurface:
		velocity.y = gravityStrength
	
	if moving:
		velocity = move_and_slide(velocity, Vector2.UP)

func ClingToFloor():
	sRotation = 0
	touchingSurface = true
	velocity = Vector2(speed, gravityStrength)

func ClingToWall():
	touchingSurface = true
	# Get space state
	var spaceState = get_world_2d().direct_space_state
	# Check if wall is to the right
	var result = spaceState.intersect_ray(position, position + Vector2(48, 0), [self], collision_mask, true, false)
	if result:
		sRotation = 270
		velocity = Vector2(gravityStrength, -speed)
		if is_on_ceiling():
			ClingToCeiling()
	else:
		sRotation = 90
		velocity = Vector2(-gravityStrength, speed)
		if is_on_floor():
			ClingToFloor()

func ClingToCeiling():
	sRotation = 180
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
