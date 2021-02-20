extends "../button.gd"

func buttonPress():
	Renderer.fade("in")
	Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
func _fadeEnd():
	Globals.LoadScene("OptionsMenu")
