extends "motion.gd"

var dashTime
var sRot

var bumpedThru = false

func enter():
	owner.animator.play("Dash")
	
	bumpedThru = false
	owner.canInput = false
	owner.canDash = false
	dashTime = owner.dashDuration
	sRot = owner.currentWeapon.rotation
	
func update(delta):
	Renderer.spawnTrail(0.1, owner.dashTexture, owner.global_position, owner.rotation, owner.scale, owner.z_index - 1, owner.body.flip_h, owner.body.flip_v)
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
			
func exit():
	owner.canInput = true
