extends "motion.gd"

var dashModulate
var dashTime

var bumpedThru = false

func enter(_msg := {}):
	bumpedThru = false
	dashModulate = owner.getShaderParam("flash_color")
	dashTime = owner.dashDuration
	
	owner.animateGraphics("dash")
	owner.setCollisionBits([CollisionLayers.ENEMY, CollisionLayers.ENEMY_PROJECTILE], false)
	
	owner.canInput = false
	owner.canDash = false
	
func update(delta):
	for part in owner.bodyParts:
		Renderer.spawnTrail(0.1, part, dashModulate)
		
	var collision = owner.move_and_collide(owner.velocity * delta)
	dashTime -= delta
	
	if collision:
		owner.velocity *= owner.bounceOff
		owner.velocity = owner.velocity.bounce(collision.normal)
		owner.canInput = false
		emit_signal("finished", "air")
		
	owner.velocity = Vector2(owner.dashStrength * owner.getFacingDirection(), 0.0)
		
	if dashTime < 0.0:
		emit_signal("finished", "previous")
			
func exit():
	owner.setCollisionBits([CollisionLayers.ENEMY, CollisionLayers.ENEMY_PROJECTILE], true)
	owner.canInput = true
