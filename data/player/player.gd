extends KinematicBody2D

var speed = 0.0
var velocity = Vector2()

export (float) var maxSpeed = 300.0
export (float) var acceleration = 25.0
export (float) var jumpStrength = 500.0
export (float) var dashStrength = 1000.0
export (float) var gravity = 800.0
export (float) var maxFallSpeed = 2000.0

onready var nodes = {
	"state_machine" : $StateMachine,
	"animator" : $Graphics/PlayerAnimator,
	"parent_sprite" : $Graphics/Body,
	"hitbox" : $CollisionShape2D,
	"cooldown" : $CooldownTimer,
	"camera" : $Camera2D
	}
	
func getInputDirection():
	var inputDirection = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	return inputDirection

func _physics_process(delta):
	velocity.x = speed
	velocity = move_and_slide(velocity, Globals.UP)
	
	if !is_on_floor():
		_applyGravity(delta)
	
	_doSnappyRotation()

func _doSnappyRotation():
	if !is_on_wall():
		if is_on_floor():
			for i in range(get_slide_count()):
				var collision = get_slide_collision(i)
				_getNode("parent_sprite").rotation = lerp(_getNode("parent_sprite").rotation, collision.normal.angle_to(Globals.UP) * -scale.x, 0.05)
		else:
			_getNode("parent_sprite").rotation = lerp(_getNode("parent_sprite").rotation, 0, 0.05)
		
func _applyGravity(delta):
	velocity.y = min(velocity.y + gravity * delta, maxFallSpeed)
	
func resetVelocity(which = "both"):
	match which:
		"x":
			velocity.x = 0
		"y":
			velocity.y = 0
		"both":
			velocity = Vector2.ZERO
			
func _getNode(node_name):
	if node_name in nodes:
		return nodes[node_name]
	else:
		printerr("¡ESE NODO NO EXISTE!")
		return null
