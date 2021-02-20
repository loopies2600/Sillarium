extends Control

onready var optionsText = $OptionsTitle
onready var itemsContainer = $Items

func _ready():
	for section in Settings._settings.keys():
		for key in Settings._settings[section].keys():
			var val = Settings._configFile.get_value(section,key)
			var newLabel = Label.new()
			
			var confiText
			
			if str(val) == "True":
				confiText = "YEAH"
				newLabel.text = ("%s: %s" % [key, confiText]).to_upper()
			elif str(val) == "False":
				confiText = "NO WAY"
				newLabel.text = ("%s: %s" % [key, confiText]).to_upper()
			elif str(val) != "Sillarium Team":
				newLabel.text = ("%s: %s" % [key, OS.get_scancode_string(int(val))]).to_upper()
			else:
				newLabel.text = ("%s: %s" % [key, val]).to_upper()
			
			newLabel.text = newLabel.text.replace("_", " ")
			
			newLabel.add_font_override("font", optionsText.get_font("normal_font"))
			itemsContainer.add_child(newLabel)
