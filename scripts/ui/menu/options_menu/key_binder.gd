extends Panel

onready var inputName = $InputName
onready var keyName = $KeyName

var inputCategory
var daddyButton
var control
var key

func _ready():
	inputName.text = tr(control).to_upper()
	keyName.text = key
	
	inputName.text = inputName.text.replace("_", " ")
	
func _input(event):
	if event is InputEventKey:
		var value = event.scancode
		Settings.setSetting(inputCategory, str(control).to_lower(), value)
		Settings.saveSettings()
		Objects.currentWorld.toggleButtons(1)
		daddyButton.updateText()
		queue_free()
