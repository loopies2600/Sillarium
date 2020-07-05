extends KinematicBody2D

# Node variables
onready var animPlayer = $Area2D/Graphics/AnimationPlayer
onready var shotStartPos = $BulletStartPosition
onready var fireTimer = $ShootTimer

# Exported variables
export (PackedScene) var projectile
export (float) var speed = 50
export (float) var firingTime = 3
export (float) var gravityStrength = 50

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
		velocity.y += gravityStrength
	
	if moving:
		velocity = move_and_slide(velocity, Vector2.UP)
	

func ClingToFloor():
	touchingSurface = true
	rotation = 0
	velocity = Vector2(speed, gravityStrength)

func ClingToWall():
	touchingSurface = true
	# Get space state
	var spaceState = get_world_2d().direct_space_state
	# Check if wall is to right
	var result = spaceState.intersect_ray(position, position + Vector2(25, 0), [self], collision_mask, true, false)
	if result:
		# Wall to the right
		rotation = PI*3/2
		velocity = Vector2(gravityStrength, -speed)
	else:
		# Wall to the left
		rotation = PI/2
		velocity = Vector2(-gravityStrength, speed)
		if is_on_floor():
			ClingToFloor()
	
	if is_on_ceiling():
		ClingToCeiling()

func ClingToCeiling():
	# Ceiling
	touchingSurface = true
	rotation = PI
	velocity = Vector2(-speed, -gravityStrength)

func PlaySlitherAnim():
	# Plays slither animation
	moving = true
	animPlayer.play("Slithering")

func OnFireTimerTimeout():
	# Plays firing animation
	moving = false
	animPlayer.play("Firing")

func Fire():
	# Creates projectile
	var newShot = projectile.instance()
	newShot.position = shotStartPos.global_position
	newShot.rotation = rotation
	get_tree().get_root().add_child(newShot)
