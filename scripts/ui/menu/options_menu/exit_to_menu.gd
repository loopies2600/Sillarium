extends "../button.gd"

func buttonPress():
	Objects.currentWorld.toggleButtons()
	var snd = Audio.playSound(7)
	
	yield(snd, "finished")
	Renderer.fade("in")
	Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
func _fadeEnd(_mode):
	Globals.LoadScene(0)
