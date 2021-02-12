extends Area2D
class_name Pickup

onready var hitbox

func _ready():
	yield(get_parent(), "ready")
	hitbox.connect("area_entered", self, "OnAreaEntered")
	hitbox.connect("body_entered", self, "OnBodyEntered")
	hitbox.connect("area_exited", self, "OnAreaExited")
	hitbox.connect("body_exited", self, "OnBodyExited")
	
func OnAreaEntered(area):
	pass
	
func OnBodyEntered(body):
	pass
	
func OnAreaExited(area):
	pass
	
func OnBodyExited(body):
	pass

