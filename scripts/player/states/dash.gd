extends "motion.gd"

var dashTime

func enter(_msg := {}):
	dashTime = owner.dashDuration
	
	var _unused = owner.connect("player_damaged", get_parent().current_state, "onDamage")
	_unused = owner.connect("grounded_updated", self, "_playerGrounded")
	
	owner.canDash = false
	owner.applyGravity = false
	owner.canInput = false
	owner.velocity.y = 0
	
	_dashTimer()
	
func physics_update(delta):
	owner.velocity.x += (owner.dashStrength * -owner.getFacingDirection())
	
func _dashTimer():
	yield(get_tree().create_timer(dashTime), "timeout")
	owner.displayTrails = true
	owner.takeDamage(0, true, (owner.maxSpeed * 4) * owner.getFacingDirection(), -owner.jumpStrength * 2)
	
func exit():
	owner.disconnect("player_damaged", get_parent().current_state, "onDamage")
	owner.disconnect("grounded_updated", get_parent().current_state, "_playerGrounded")
	
	owner.applyGravity = true
