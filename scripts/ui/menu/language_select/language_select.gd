extends Control

export (int) var bgID = 4
onready var language = Settings.getSetting("dont-autogenerate-buttons", "lang")

onready var languageText = $LanguageTitle
onready var buttons = [$Languages/English, $Languages/Espanol, $Languages/Portugues]

var toScreen := true

func _ready():
	Objects.registerEveryNode()
	
	languageText.bbcode_text = "[wave amp=32]" + tr("LM_LANGUAGE")
	
	TranslationServer.set_locale(language)
	Renderer.fade("out")
	Renderer.backgroundSetup(bgID, {"dontShowCones" : false})
	
	for button in buttons:
		button.connect("mouse_entered", self, "_onMouseEnter")
		button.connect("pressed", self, "_on" + button.name + "Pressed")
	
func _onMouseEnter():
	for button in buttons:
		if !button.disabled:
			Audio.playSound(8)
	
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
	for button in buttons:
		if button.has_focus():
			button.release_focus()
			
		button.disabled = true
		
	var snd = Audio.playSound(6)
	
	language = Settings.getSetting("dont-autogenerate-buttons", "lang")
	TranslationServer.set_locale(language)
	Settings.saveSettings()
	
	yield(snd, "finished")
	Renderer.fade("in")
	_connectDaFade()
	
func _connectDaFade():
	var connection = Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
	if connection:
		Renderer.transition.disconnect("fade_finished", self, "_fadeEnd")
		connection = null
		connection = Renderer.transition.connect("fade_finished", self, "_fadeEnd")
		
func _fadeEnd(_mode):
	if Objects.previousScene:
		return get_tree().change_scene(Objects.previousScene)
	else:
		Globals.LoadScene(0, {"activePrompt": true})

