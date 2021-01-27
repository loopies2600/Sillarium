extends "../button.gd"

func buttonPress():
	Renderer.fade("in")
	Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
func _fadeEnd():
	get_tree().quit()
	get_tree().get_root().queue_free()
