extends Control

onready var mat = $Shader.get_material()
onready var grad2 = $Shader.texture.gradient
onready var buttons = [$Languages/English, $Languages/Espanol, $Languages/Portugues]

var toScreen := true

func _init():
	Objects.currentWorld = self
	
func _ready():
	Renderer.fade("out")
	
	for button in buttons:
		button.connect("pressed", self, "_on" + button.name + "Pressed")
		
func _process(_delta):
	toScreen = !toScreen
	mat.set_shader_param("toScreen", toScreen)
	grad2.set_color(0, Color(rand_range(0.0, 0.5), rand_range(0.0, 0.5), rand_range(0.0, 0.5), 0.25))
	grad2.set_color(1, Color(rand_range(0.0, 0.25), rand_range(0.0, 0.25), rand_range(0.0, 0.25), 0.0))
	
func _onEnglishPressed():
	TranslationServer.set_locale("en")
	_returnToScene()
	
func _onEspanolPressed():
	TranslationServer.set_locale("es")
	_returnToScene()
	
func _onPortuguesPressed():
	TranslationServer.set_locale("pt")
	_returnToScene()
	
func _returnToScene():
	Renderer.fade("in")
	Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
func _fadeEnd():
	if Objects.previousWorld:
		return get_tree().change_scene(Objects.previousWorld)
	else:
		Globals.LoadScene(0)

