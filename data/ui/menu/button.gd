extends Button

var isPressed = false

func _ready():
	connect("pressed", self, "buttonPress")
	
func buttonPress():
	pass
