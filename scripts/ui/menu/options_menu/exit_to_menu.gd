extends "../button.gd"

func buttonPress():
	var snd = Audio.playSound(7)
	yield(snd, "finished")
	
	if get_tree().get_current_scene().categoryOpen:
		get_tree().get_current_scene().categoryOpen = false
	else:
		get_tree().get_current_scene().toggleButtons()
		Renderer.fade("in")
		Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
func _onCategorySwitch(isOpen):
	if isOpen:
		text = "BACK"
	else:
		text = "EXIT"
		
func _fadeEnd(_mode):
	Globals.LoadScene(0)
