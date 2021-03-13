extends "motion.gd"

func enter(msg := {}):
	owner.playRandomAnim(["Hurt0"])
	
	owner.snapVector = Vector2.ZERO
	owner.velocity = Vector2.ZERO
	
	owner.velocity += Vector2(msg.x, msg.y)
	
	owner.canInput = false
	emit_signal("finished", "air")
