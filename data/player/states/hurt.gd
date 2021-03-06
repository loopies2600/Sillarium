extends "motion.gd"

func enter(msg := {}):
	owner.playRandomAnim(["Hurt0"])
	owner.startGracePeriod()
	owner.canInput = !owner.canInput
	
	if !owner.flashing:
		owner.snap = false
		owner.velocity = Vector2.ZERO
		owner.velocity -= Vector2(owner.currentBump, abs(owner.currentBump) * 2)
		owner.health -= owner.currentDamage
		owner.flashing = true
		
func update(delta):
	owner.animspeedAsVelocity()
	owner.moveAndSnap(delta)
	
	if owner.health <= 0:
			owner.kill()
			
	if owner.is_on_floor():
		emit_signal("finished", "idle")
		
func exit(msg := {}):
	owner.canInput = !owner.canInput
