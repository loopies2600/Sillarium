extends Control

onready var buttons = [$Languages/English, $Languages/Espanol, $Languages/Portugues]

func _init():
	Objects.currentWorld = self
	
func _ready():
	Renderer.fade("out")
	
	for button in buttons:
		button.connect("pressed", self, "_on" + button.name + "Pressed")
		
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
		Globals.LoadScene(Objects.previousWorld)
	else:
		Globals.LoadScene("MainMenu")

