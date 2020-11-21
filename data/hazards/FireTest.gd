extends Area2D

var i = 1
var isParent = true

func _ready():
	if isParent:
		$Iterationer.connect("timeout", self, "_Iterate")
	
func _spawnFlame(offset, direction):
	var newFlame = load("res://scenes/hazards/FireTest.tscn").instance()
	newFlame.position.x = position.x + (offset * direction)
	newFlame.isParent = false
	get_parent().add_child(newFlame)
	
func _Iterate():
	_spawnFlame(64 * i, -1)
	_spawnFlame(64 * i, 1)
	i += 1
	
func _destroy():
	queue_free()
