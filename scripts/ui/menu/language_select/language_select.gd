extends Control

export (int) var bgID = 4
onready var language = Settings.getSetting("dont-autogenerate-buttons", "lang")

onready var buttons = [$Languages/English, $Languages/Espanol, $Languages/Portugues]

var toScreen := true

func _init():
	Objects.currentWorld = self
	
func _ready():
	TranslationServer.set_locale(language)
	Renderer.fade("out")
	Renderer.backgroundSetup(bgID)
	
	for button in buttons:
		button.connect("pressed", self, "_on" + button.name + "Pressed")
	
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
	_connectDaFade()
	
func _connectDaFade():
	var connection = Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
	if connection:
		Renderer.transition.disconnect("fade_finished", self, "_fadeEnd")
		connection = null
		connection = Renderer.transition.connect("fade_finished", self, "_fadeEnd")
		
func _fadeEnd(_mode):
	if Objects.previousWorld:
		return get_tree().change_scene(Objects.previousWorld)
	else:
		Globals.LoadScene(0)

