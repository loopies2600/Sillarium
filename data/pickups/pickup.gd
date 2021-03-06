extends Area2D
class_name Pickup

onready var hitbox

func _ready():
	yield(get_parent(), "ready")
	hitbox.connect("area_entered", self, "OnAreaEntered")
	hitbox.connect("body_entered", self, "OnBodyEntered")
	hitbox.connect("area_exited", self, "OnAreaExited")
	hitbox.connect("body_exited", self, "OnBodyExited")
	
# warning-ignore:unused_argument
func OnAreaEntered(area):
	pass
	
# warning-ignore:unused_argument
func OnBodyEntered(body):
	pass
	
# warning-ignore:unused_argument
func OnAreaExited(area):
	pass
	
# warning-ignore:unused_argument
func OnBodyExited(body):
	pass

