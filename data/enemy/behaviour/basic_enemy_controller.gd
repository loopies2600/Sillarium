extends KinematicBody2D

signal DestroySelf

onready var hitbox

export (int) var health = 50
export (int) var damage = 2
export (bool) var killsPlayer = true

func _ready():
	yield(owner, "ready")
	hitbox.connect("area_entered", self, "OnAreaEntered")
	hitbox.connect("body_entered", self, "OnBodyEntered")

func OnAreaEntered(area):
	if area.is_in_group("PlayerProjectile"):
		area.kill()
		emit_signal("DestroySelf")

func OnBodyEntered(body):
	if body.is_in_group("Player") and killsPlayer:
		body.takeDamage(damage)
		pass
