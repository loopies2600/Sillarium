extends State

func enter(_msg := {}):
	var _unused = owner.connect("player_damaged", get_parent().current_state, "onDamage")
	_unused = owner.connect("grounded_updated", get_parent().current_state, "_playerGrounded")
	
func _playerGrounded(isGrounded):
	if isGrounded:
		owner.canDash = true
	else:
		emit_signal("finished", "air")
	
func update(_delta):
	if owner.isGrounded:
			if owner.canInput:
				if Input.is_action_just_pressed("jump" + owner.inputSuffix):
					emit_signal("finished", "air", {isJump = true})
				if Input.is_action_pressed("input_hold" + owner.inputSuffix):
					emit_signal("finished", "hold")
	else:
		if owner.canDash:
			if owner.canInput:
				if Input.is_action_just_pressed("dash" + owner.inputSuffix):
					emit_signal("finished", "dash")
		
func onDamage(bumpX, bumpY, deadly := false):
	emit_signal("finished", "bump", {"x" : bumpX, "y" : bumpY, "isDeadly" : deadly})
	
func exit():
	owner.disconnect("player_damaged", get_parent().current_state, "onDamage")
	owner.disconnect("grounded_updated", get_parent().current_state, "_playerGrounded")
