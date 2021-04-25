extends "../button.gd"

func buttonPress():
	Audio.playSound(6)
	
	Renderer.fade("in")
	Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
func _fadeEnd(_mode):
	Globals.LoadScene(2)
