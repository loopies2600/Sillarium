extends "motion.gd"

var dashTime
var sRot

var bumpedThru = false

func enter(msg := {}):
	owner.animator.play("Dash")
	owner.setCollisionBits([2, 3], false)
	
	bumpedThru = false
	owner.canInput = false
	owner.canDash = false
	dashTime = owner.dashDuration
	sRot = owner.currentWeapon.rotation
	
func update(delta):
	Renderer.spawnTrail(0.1, owner.dash)
	var collision = owner.move_and_collide(owner.velocity * delta)
	dashTime -= delta
	
	if collision:
		owner.velocity *= owner.bounceOff
		owner.velocity = owner.velocity.bounce(collision.normal)
		bumpedThru = true
		emit_signal("finished", "previous")
		
	if !bumpedThru:
		owner.velocity = Vector2(owner.dashStrength * owner.getFacingDirection(), 0.0)
		
		if dashTime < 0.0:
			emit_signal("finished", "previous")
			
func exit():
	owner.setCollisionBits([2, 3], true)
	owner.canInput = true
