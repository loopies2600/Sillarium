extends "motion.gd"

var dashTime
var desiredDirection

func enter(_msg := {}):
	dashTime = owner.dashDuration
	desiredDirection = owner.weapon.rotation
	
	owner.canDash = false
	owner.applyGravity = false
	owner.canInput = false
	owner.velocity.y = 0
	
	_dashTimer()
	
func physics_update(_delta):
	owner.velocity += Vector2(-owner.dashStrength / 32, 0).rotated(desiredDirection)
	
func _dashTimer():
	yield(get_tree().create_timer(dashTime), "timeout")
	owner.animateGraphics("dash")
	owner.displayTrails = true
	
	owner.velocity = Vector2.ZERO
	owner.velocity += Vector2(owner.dashStrength, 0).rotated(desiredDirection)
	owner.velocity.y -= owner.dashStrength / 4
	
	emit_signal("finished", "air")
	
	
func exit():
	owner.applyGravity = true
