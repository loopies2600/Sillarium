extends "../button.gd"

func buttonPress():
	Audio.playSound(7)
	
	Renderer.fade("in")
	Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
func _fadeEnd(_mode):
	Globals.LoadScene(0)
