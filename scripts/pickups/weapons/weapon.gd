extends Pickup

export (int) var weaponID = 0

func _ready():
	hitbox = self
	
func OnBodyEntered(body):
	if body is Player:
		body.pickUpWeapon(weaponID)
		queue_free()
