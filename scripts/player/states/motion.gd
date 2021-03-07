extends State

func _ready():
	var _unused = owner.connect("player_damaged", self, "onDamage")
	_unused = owner.connect("player_grounded_updated", self, "_playerGrounded")
	
func _playerGrounded(isGrounded):
	if isGrounded:
		owner.canInput = true
		owner.canDash = true
	else:
		emit_signal("finished", "air")
	
func update(_delta):
	if owner.is_on_floor():
			if owner.canInput:
				if Input.is_action_pressed("jump"):
					emit_signal("finished", "air", {isJump = true})
				if Input.is_action_pressed("input_hold"):
					emit_signal("finished", "hold")
	else:
		if owner.canDash:
			if owner.canInput:
				if Input.is_action_just_pressed("dash"):
					emit_signal("finished", "dash")
		
func move(maxVel, direction):
	owner.velocity.x = clamp(owner.velocity.x + (direction * owner.acceleration), -maxVel, maxVel)
	
func damp():
	if owner.is_on_floor():
		owner.velocity.x *= owner.friction
	else:
		owner.velocity.x *= owner.airFriction
	
func onDamage():
	emit_signal("finished", "hurt")
