extends KinematicBody2D

export(Resource) var rideable
export (int) var riderPosOffset = -48
export (float, 0.0, 1.0) var syncDelay = 0.25

onready var maxSpeed = rideable.maxSpeed
onready var airMaxSpeed = rideable.airMaxSpeed
onready var acceleration = rideable.acceleration
onready var friction = rideable.friction
onready var airFriction = rideable.airFriction
onready var jumpStrength = rideable.jumpStrength
onready var timeJumpApex = rideable.timeJumpApex
onready var fallMultiplier = rideable.fallMultiplier

var velocity := Vector2()
var groundAngle = -1
var snapAngle := Vector2(0.0, Globals.MAX_FLOOR_ANGLE)
var gravity
var jumpForce

var rider

var currentDamage := 0
var currentBump := 0.0

var flashing := false
var snap := true

onready var stateMachine = $StateMachine
onready var animator = $Animator
onready var renderer = $Graphics
onready var hitbox = $Area2D
onready var riderPos = $RiderPosition
onready var collisionBox = $CollisionBox

func _ready():
	hitbox.connect("area_entered", self, "_areaEnter")
	hitbox.connect("body_entered", self, "_bodyEnter")
	
func _physics_process(delta):
	moveAndSnap(delta)
	animspeedAsVelocity()
	flashBehaviour()
	
func animspeedAsVelocity():
	if getInputDirection():
		animator.playback_speed = min(animator.playback_speed + 0.05, 1.0)
	else:
		animator.playback_speed = 1.0
		
	if getInputDirection() == 1.0:
		riderPos.position.x = riderPosOffset
		renderer.flip_h = false
	if getInputDirection() == -1.0:
		riderPos.position.x = -riderPosOffset
		renderer.flip_h = true
	
func moveAndSnap(delta):
	if rider:
		rider.global_position = lerp(rider.global_position, riderPos.global_position, syncDelay)
	gravity = (2 * jumpStrength) / pow(timeJumpApex, 2)
	jumpForce = gravity * timeJumpApex
	
	if !is_on_floor():
		velocity.y += gravity * delta * (fallMultiplier if velocity.y > 0 else 1)
		
	if snap:
		snapAngle = Vector2(0.0, Globals.MAX_FLOOR_ANGLE)
	else:
		snapAngle = Vector2()
		
	velocity = move_and_slide_with_snap(velocity, snapAngle, Globals.UP, true)
	
func flashBehaviour():
	if flashing:
		visible = !visible
		
func getInputDirection() -> int:
	if rider:
		var inputDirection = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		return inputDirection
	return 0
		
func takeDamage(damage, bump = maxSpeed * -1 if renderer.flip_h else maxSpeed * 1):
	currentDamage = damage
	currentBump = bump
	emit_signal("player_damaged")

func reinitializeVars():
	maxSpeed = rideable.maxSpeed
	acceleration = rideable.acceleration
	friction = rideable.friction
	airFriction = rideable.airFriction
	jumpStrength = rideable.jumpStrength
	timeJumpApex = rideable.timeJumpApex
	fallMultiplier = rideable.fallMultiplier
	
func _bodyEnter(body):
	if body.is_in_group("Player"):
		rider = body
		body.riding = true
		body.velocity = Vector2()
		body.disableCollisionBox()
			
func _on_WrapArea_area_entered(area):
	global_position = Vector2(512, global_position.y)
