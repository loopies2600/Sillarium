extends "motion.gd"

var dashTime
var sRot

var bumpedThru = false

func enter():
	bumpedThru = false
	owner.canDash = false
	dashTime = owner.dashDuration
	sRot = owner.currentWeapon.rotation
	
func update(delta):
	Renderer.spawnTrail(0.1, owner.dashTexture, owner.global_position, owner.rotation, owner.scale)
	var collision = owner.move_and_collide(owner.velocity * delta)
	dashTime -= delta
	
	if collision:
		owner.velocity *= owner.bounceOff
		owner.velocity = owner.velocity.bounce(collision.normal)
		bumpedThru = true
		emit_signal("finished", "idle")
		
	if !bumpedThru:
		owner.velocity = Vector2(owner.dashStrength, 0.0).rotated(sRot)
		
		if dashTime < 0.0:
			emit_signal("finished", "idle")
