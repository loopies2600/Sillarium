extends Sprite

var particles = Settings.getSetting("renderer", "particles")

var fadeSpeed := 0.1
var life := 1.0
var modulation := Color.white
var randomColors := false

func _init():
	if !particles:
		queue_free()
		
func _ready():
	set_material(material.duplicate())
	
	if randomColors:
		_setColor(Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), 1.0))
	else:
		_setColor(modulation)
	
func _setColor(color : Color):
	get_material().set_shader_param("flash_color", color)
	
func _process(_delta):
	if randomColors:
		_setColor(Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), 1.0))
	
	life -= fadeSpeed
	get_material().set_shader_param("opacity", life)
	
	if (life <= 0):
		queue_free()
