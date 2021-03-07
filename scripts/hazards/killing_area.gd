extends Area2D

func _ready():
	var _unused = connect("body_entered", self, "OnBodyEnter")

func OnBodyEnter(body):
	if body.is_in_group("Player"):
		#body.Respawn()
		pass
