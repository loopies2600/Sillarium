extends "motion.gd"

var dashTime

func enter(_msg := {}):
	owner.canDash = false
	dashTime = owner.dashDuration
	
	owner.animateGraphics("dash")
	owner.setCollisionBits([CollisionLayers.ENEMY, CollisionLayers.ENEMY_PROJECTILE], false)
	
	owner.applyGravity = false
	owner.canInput = false
	owner.velocity.y = 0
	
func update(delta):
	var dashModulate = owner.getShaderParam("flash_color")
	
	for part in owner.bodyParts:
		Renderer.spawnTrail(0.1, part, dashModulate)
		
	dashTime -= delta
	
	owner.velocity.x += owner.dashStrength * owner.getFacingDirection()
		
	if dashTime < 0.0:
		emit_signal("finished", "previous")
			
func exit():
	owner.setCollisionBits([CollisionLayers.ENEMY, CollisionLayers.ENEMY_PROJECTILE], true)
	owner.applyGravity = true
	owner.canInput = true
