extends "../button.gd"

func buttonPress():
	if !isPressed:
		Globals.fade("in")
		Globals.transition.connect("fade_finished", self, "_fadeEnd")
		isPressed = true
	
func _fadeEnd():
	get_tree().quit()
	get_tree().get_root().queue_free()
