extends State

func _ready():
	var _unused = owner.connect("player_damaged", self, "onDamage")
	_unused = owner.connect("player_grounded_updated", self, "_playerGrounded")
	
func _playerGrounded(isGrounded):
	if isGrounded:
		owner.canDash = true
	else:
		emit_signal("finished", "air")
	
func update(_delta):
	if owner.is_on_floor():
			if owner.canInput:
				if Input.is_action_pressed("jump" + owner.inputSuffix):
					emit_signal("finished", "air", {isJump = true})
				if Input.is_action_pressed("input_hold" + owner.inputSuffix):
					emit_signal("finished", "hold")
	else:
		if owner.canDash:
			if owner.canInput:
				if Input.is_action_just_pressed("dash" + owner.inputSuffix):
					emit_signal("finished", "dash")
		
func onDamage(bumpX, bumpY):
	emit_signal("finished", "hurt", {x = bumpX, y = bumpY})
