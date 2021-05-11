extends Object
class_name TextureSetter

func _ready():
	reloadTex()
	
func reloadTex(list := ""):
	return Loader.getTexture(list)
