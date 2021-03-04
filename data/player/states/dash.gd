extends "motion.gd"

var dashTime
var sRot

var bumpedThru = false

func enter():
	owner.animator.play("Dash")
	owner.setEnemyCollision(false)
	
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
		emit_signal("finished", "idle")
		
	if !bumpedThru:
		owner.velocity = Vector2(owner.dashStrength * owner.getFacingDirection(), 0.0)
		
		if dashTime < 0.0:
			emit_signal("finished", "idle")
			
func exit():
	owner.setEnemyCollision(true)
	owner.canInput = true
