extends KinematicBody2D

export (float) var maxSpeed = 400.0
export (float) var acceleration = maxSpeed / 5.0
export (float) var friction = acceleration
export (float) var jumpStrength = 150.0
export (float) var timeJumpApex = 0.4
export (float) var fallMultiplier = 1.5
export (float) var dashStrength = 1000.0

export (Texture) var playerNumberTexture

var velocity := Vector2()
var groundAngle = -1
var snap = true
var snapAngle := Vector2(0.0, Globals.MAX_FLOOR_ANGLE)

var gravity
var jumpForce

var weapon
var currentWeapon
var weaponIndex = 0

onready var nodes = {
	"arms_position" : $Graphics/Body/ArmsPosition,
	"state_machine" : $StateMachine,
	"animator" : $Graphics/PlayerAnimator,
	"parent_sprite" : $Graphics/Body,
	"hitbox" : $CollisionShape2D,
	"cooldown" : $CooldownTimer,
	"camera" : $Camera2D
	}
	
func _ready():
	Globals.set("player", self)
	$Graphics/PlayerNumber.texture = playerNumberTexture
	
	loadWeapon(weaponIndex)
	
func _physics_process(delta): 
	if Input.is_action_just_pressed("wps_left"):
		switchWeapon(-1)
	if Input.is_action_just_pressed("wps_right"):
		switchWeapon(1)
	
	animspeedAsVelocity()
	moveAndSnap(delta)
	
func animspeedAsVelocity():
	if velocity.x != 0:
		getNode("animator").playback_speed = velocity.x / maxSpeed
	else:
		getNode("animator").playback_speed = 1
	
func moveAndSnap(delta):
	gravity = (2 * jumpStrength) / pow(timeJumpApex, 2)
	jumpForce = gravity * timeJumpApex
	
	velocity.y += gravity * delta * (fallMultiplier if velocity.y > 0 else 1)
		
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		groundAngle = collision.normal.angle()
	
	if snap:
		snapAngle = Vector2(0.0, Globals.MAX_FLOOR_ANGLE)
	else:
		snapAngle = Vector2()
		
	velocity = move_and_slide_with_snap(velocity, snapAngle, Vector2(0, groundAngle), true)
	
func getNode(node_name):
	if node_name in nodes:
		return nodes[node_name]
	else:
		printerr("¡ESE NODO NO EXISTE!")
		return null
	
func loadWeapon(weaponID):
	var inheritFireAngle = 0
	
	if weapon != null:
		inheritFireAngle = weapon.fireAngle
		weapon.queue_free()
		
	var wps = load(Globals.LoadJSON("res://data/json/weapons.json", weaponID)["file"])
	currentWeapon = wps
	weapon = currentWeapon.instance()
	add_child(weapon)
	weapon.fireAngle = inheritFireAngle
	weapon.armsPos = getNode("arms_position")
	
func switchWeapon(dir):
	weaponIndex += 1 * dir
	loadWeapon(weaponIndex)
	reinitializeVars()
		
func reinitializeVars():
	maxSpeed = 400.0
	acceleration = 25.0
	friction = acceleration
	jumpStrength = 150.0
	dashStrength = 1000.0
	gravity = 20.0
