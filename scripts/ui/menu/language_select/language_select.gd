extends Control

onready var language = Settings.getSetting("dont-autogenerate-buttons", "lang")

onready var mat = $Shader.get_material()
onready var grad2 = $Shader.texture.gradient
onready var buttons = [$Languages/English, $Languages/Espanol, $Languages/Portugues]

var toScreen := true

func _init():
	Objects.currentWorld = self
	
func _ready():
	TranslationServer.set_locale(language)
	Renderer.fade("out")
	
	for button in buttons:
		button.connect("pressed", self, "_on" + button.name + "Pressed")
		
func _process(_delta):
	toScreen = !toScreen
	mat.set_shader_param("toScreen", toScreen)
	grad2.set_color(0, Color(rand_range(0.0, 0.5), rand_range(0.0, 0.5), rand_range(0.0, 0.5), 0.25))
	grad2.set_color(1, Color(rand_range(0.0, 0.25), rand_range(0.0, 0.25), rand_range(0.0, 0.25), 0.0))
	
func _onEnglishPressed():
	Settings.setSetting("dont-autogenerate-buttons", "lang", "en")
	_returnToScene()
	
func _onEspanolPressed():
	Settings.setSetting("dont-autogenerate-buttons", "lang", "es")
	_returnToScene()
	
func _onPortuguesPressed():
	Settings.setSetting("dont-autogenerate-buttons", "lang", "pt")
	_returnToScene()
	
func _returnToScene():
	language = Settings.getSetting("dont-autogenerate-buttons", "lang")
	TranslationServer.set_locale(language)
	Settings.saveSettings()
	Renderer.fade("in")
	Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
func _fadeEnd(_mode):
	if Objects.previousWorld:
		return get_tree().change_scene(Objects.previousWorld)
	else:
		Globals.LoadScene(0)

