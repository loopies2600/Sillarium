extends HSlider

export (String) var targetAudioBus = "Master"

onready var _bus : int = AudioServer.get_bus_index(targetAudioBus)
onready var _busName : String = targetAudioBus.to_lower() 

func _ready() -> void:
	var _unused = connect("value_changed", self, "_onValueChanged")
	_unused = connect("mouse_exited", self, "release_focus")
	value = Audio.get(_busName + "Volume")
	
func _process(_delta) -> void:
	if Audio.mute:
		value = 0.0
		
func _onValueChanged(value: float) -> void:
	Settings.setSetting("dont-autogenerate-buttons", _busName + "_volume", value)
	Audio.reloadVolume()
	Audio.musicSetup(owner.musicID)
