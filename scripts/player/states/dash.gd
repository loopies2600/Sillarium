extends "motion.gd"

var dashTime

func enter(_msg := {}):
	var _unused = owner.connect("player_damaged", get_parent().current_state, "onDamage")
	_unused = owner.connect("player_grounded_updated", self, "_playerGrounded")
	
	owner.canDash = false
	dashTime = owner.dashDuration
	
	owner.setCollisionBits([CollisionLayers.ENEMY, CollisionLayers.ENEMY_PROJECTILE], false)
	
	owner.applyGravity = false
	owner.canInput = false
	owner.velocity.y = 0
	
func physics_update(delta):
	for part in owner.bodyParts:
		Renderer.spawnTrail(0.1, part, "random")
		
	dashTime -= delta
	
	owner.velocity.x += (owner.dashStrength * owner.getFacingDirection())
	
	if owner.get_slide_count() > 0:
		owner.takeDamage(0, true)
		
	if dashTime < 0.0:
		emit_signal("finished", "previous")
			
func exit():
	owner.disconnect("player_damaged", get_parent().current_state, "onDamage")
	owner.disconnect("player_grounded_updated", get_parent().current_state, "_playerGrounded")
	
	owner.setCollisionBits([CollisionLayers.ENEMY, CollisionLayers.ENEMY_PROJECTILE], true)
	owner.applyGravity = true
	owner.canInput = true
