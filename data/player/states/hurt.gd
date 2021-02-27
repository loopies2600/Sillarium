extends "motion.gd"

func enter():
	owner.startGracePeriod()
	owner.canShoot = !owner.canShoot
	
	if !owner.flashing:
		owner.snap = false
		owner.velocity = Vector2.ZERO
		owner.velocity -= Vector2(owner.currentBump, abs(owner.currentBump) * 2)
		owner.health -= owner.currentDamage
		owner.flashing = true
		
func update(delta):
	owner.animspeedAsVelocity()
	owner.moveAndSnap(delta)
	
	owner.graphics.rotation += 0.25
	
	if owner.health <= 0:
			Globals.player = null
			owner.queue_free()
		
	if owner.is_on_floor():
		emit_signal("finished", "idle")
		
func exit():
	owner.graphics.rotation = 0.0
	owner.canShoot = !owner.canShoot
