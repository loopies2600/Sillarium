extends "../button.gd"

func buttonPress():
	Globals.fade("in")
	Globals.transition.connect("fade_finished", self, "_fadeEnd")
	
func _fadeEnd():
	Globals.LoadLevel("TestTutorial")
