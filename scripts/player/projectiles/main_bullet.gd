extends "res://scripts/projectile/projectile.gd"

func _ready():
	sprite = $Sprite
	hitbox = $CollisionShape2D
	
	initialize()
