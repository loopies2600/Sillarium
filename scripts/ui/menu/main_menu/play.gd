extends "../button.gd"

func buttonPress():
	Renderer.fade("in")
	Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
func _fadeEnd(_mode):
	Globals.LoadScene(3)
