extends Button

var selectedButton = null
var buttonID := 0

func _ready():
	var _unused = connect("pressed", self, "buttonPress")
	_unused = connect("mouse_entered", self, "onMouseEnter")
	_unused = connect("mouse_exited", self, "onMouseExit")
	
func buttonPress():
	pass
	
func onMouseEnter():
	Audio.playSound(8)
	
func onMouseExit():
	selectedButton = null
