extends Kinematos
class_name Hazard

# warning-ignore:unused_signal
signal destroyed

onready var hitbox : Area2D

export (int) var damage = 2

func _ready():
	yield(get_parent(), "ready")
	var _unused = hitbox.connect("area_entered", self, "onAreaEntered")
	_unused = hitbox.connect("body_entered", self, "onBodyEntered")
	_unused = hitbox.connect("area_exited", self, "onAreaExited")
	_unused = hitbox.connect("body_exited", self, "onBodyExited")
	
func onAreaEntered(_area):
	pass
	
func onBodyEntered(body):
	if body is Player:
		body.takeDamage(damage)
	
func onAreaExited(_area):
	pass
	
func onBodyExited(_body):
	pass
