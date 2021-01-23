extends "motion.gd"

func enter():
	if !owner.flashing:
		owner.snap = false
		owner.velocity = Vector2.ZERO
		owner.velocity -= Vector2(owner.currentBump, abs(owner.currentBump) * 2)
		owner.health -= owner.currentDamage
		owner.flashing = true
		
func update(_delta):
	cancelVelocity()
	
	if owner.is_on_floor():
		if owner.health <= 0:
			Globals.player = null
			owner.queue_free()
		
		owner.visible = true
		owner.flashing = false
		emit_signal("finished", "idle")
