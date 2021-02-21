extends Panel

onready var inputName = $InputName
onready var keyName = $KeyName

var daddyButton
var control
var key

func _ready():
	inputName.text = control
	keyName.text = key
	
	inputName.text = inputName.text.replace("_", " ")
	
func _input(event):
	if event is InputEventKey:
		var value = event.scancode
		Settings.setSetting("controls", str(control).to_lower(), value)
		Settings.saveSettings()
		Objects.currentWorld.toggleButtons(1)
		daddyButton.updateText()
		queue_free()
