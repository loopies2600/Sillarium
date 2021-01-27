extends Button

func _ready():
	connect("pressed", self, "buttonPress")
	
func buttonPress():
	pass
