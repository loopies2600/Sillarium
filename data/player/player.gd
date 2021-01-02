extends KinematicBody2D

export (float) var maxSpeed = 300.0
export (float) var jumpStrength = 600.0
export (float) var dashStrength = 1000.0
export (float) var gravity = 800.0

export (PackedScene) var weapon

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
	
	var theWeapon = weapon.instance()
	add_child(theWeapon)
	theWeapon.position = position - Vector2(0, 24)
	
func _getNode(node_name):
	if node_name in nodes:
		return nodes[node_name]
	else:
		printerr("¡ESE NODO NO EXISTE!")
		return null
