extends State

var desiredDirection

func enter(_msg := {}):
	desiredDirection = owner.weapon.rotation
	
	owner.applyGravity = false
	owner.canDash = false
	owner.canInput = false
	owner.velocity = Vector2()
	
	_dashTimer()
	
func _dashTimer():
	owner.animateGraphics("dash")
	owner.displayTrails = true
	owner.velocity = Vector2(owner.dashStrength, 0).rotated(desiredDirection)
	
	emit_signal("finished", "air")
	
func exit():
	owner.applyGravity = true
