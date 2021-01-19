extends "motion.gd"

func enter():
	owner.getNode("animator").play("Walking")
	
func update(delta):
	move(owner.maxSpeed, getInputDirection())
	
	
	if not getInputDirection():
		emit_signal("finished", "idle")
		
	owner.weapon.setFiringDirection(delta)
