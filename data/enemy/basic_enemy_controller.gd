extends Area2D

signal DestroySelf

export (float) var health = 50
export (bool) var killsPlayer = true

func _ready():
	connect("area_entered", self, "OnAreaEntered")
	connect("body_entered", self,"OnBodyEntered")

func OnAreaEntered(area):
	if area.is_in_group("PlayerProjectile"):
		area.queue_free()
		emit_signal("DestroySelf")

func OnBodyEntered(body):
	if body.is_in_group("Player") and killsPlayer:
		body.Respawn()
