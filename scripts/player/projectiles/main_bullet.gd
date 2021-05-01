extends "res://scripts/projectile/projectile.gd"

func _ready():
	sprite = $Sprite
	hitbox = $CollisionShape2D
	
	initialize()
	
func _process(_delta):
	Renderer.spawnTrail(0.3, sprite, Color.yellow)
