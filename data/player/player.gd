extends KinematicBody2D

export (float) var maxSpeed = 400.0
export (float) var acceleration = 25.0
export (float) var friction = acceleration
export (float) var jumpStrength = 600.0
export (float) var dashStrength = 1000.0
export (float) var gravity = 20.0

var velocity := Vector2()
var groundAngle = -1
var snap = true
var snapAngle := Vector2(0.0, Globals.MAX_FLOOR_ANGLE)

export (PackedScene) var weapon
var theWeapon

onready var nodes = {
	"state_machine" : $StateMachine,
	"animator" : $Graphics/PlayerAnimator,
	"parent_sprite" : $Graphics/Body,
	"hitbox" : $CollisionShape2D,
	"cooldown" : $CooldownTimer,
	"camera" : $Camera2D
	}
	
func _ready():
	Globals.set("player", self)
	
	theWeapon = weapon.instance()
	add_child(theWeapon)
	theWeapon.global_position = global_position - Vector2(0, 24)
	
func _physics_process(delta):
	velocity.y += gravity
	
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
