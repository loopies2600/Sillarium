extends Sprite

onready var visibility = $VisibilityNotifier2D
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
	visibility.connect("screen_exited", self, "_kill")
	
	if randomColors:
		_setColor(Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), 1.0))
	else:
		_setColor(modulation)
	
func _setColor(color : Color):
	var material = self.get_material()
	material.set_shader_param("flash_color", color)
	
func _process(_delta):
	if randomColors:
		_setColor(Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1), 1.0))
	
	modulate.a = life
	life -= fadeSpeed
	
	if (life <= 0):
		_kill()
		
func _kill():
	queue_free()
