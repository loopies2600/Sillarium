extends Area2D

func _ready():
	connect("body_entered", self, "OnBodyEnter")

func OnBodyEnter(body):
	if body.is_in_group("Player"):
		body.Respawn()
