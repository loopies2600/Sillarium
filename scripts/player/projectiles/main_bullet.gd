extends Projectile

func _ready():
	sprite = $Sprite
	hitbox = $CollisionShape2D
	
	initialize()
