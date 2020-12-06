extends "motion.gd"

func enter():
	owner.resetVelocity()
	
func update(delta):
	var sprites = owner._getNode("parent_sprite")

	Globals.CreateTrail(0.1, sprites.texture, sprites.global_position, sprites.global_rotation, sprites.global_scale, -128)
	for _i in sprites.get_children():
		Globals.CreateTrail(0.1, _i.texture, _i.global_position, _i.global_rotation, _i.global_scale, -128)
	
	owner.resetVelocity("y")
	owner.speed = owner.dashStrength * sprites.scale.x
	
	if owner.get_slide_count() != 0:
		emit_signal("finished", "idle")
