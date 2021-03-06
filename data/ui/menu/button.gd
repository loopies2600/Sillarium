extends Button

func _ready():
	var _unused = connect("pressed", self, "buttonPress")
	
func buttonPress():
	pass
