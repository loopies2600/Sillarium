extends Projectile

export (int) var maxBounces := 5

var bounces := 0 setget _setBounces

func _ready():
	boundaries = $Hitbox/Boundaries
	hitbox = $Hitbox
	sprite = $Bubbly
	
	initialize()
	renderShadow(self)
	
func setupSpeed():
	velocity = speed.rotated(rotation)
	velocity.y -= initialJump
	rotation = 0
	
func mainMotion(delta):
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity = velocity.bounce(collision.normal)
		velocity *= bounciness
		self.bounces += 1
		
func _setBounces(value : int):
	if bounces == maxBounces:
		kill()
		
	bounces = value
