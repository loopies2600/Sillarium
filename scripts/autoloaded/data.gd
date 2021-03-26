extends Node

enum {LOAD_SUCCESS, LOAD_ERROR_COULDNT_OPEN}

const SAVE_FORMAT = ".sillarium"
const SAVE_PATH = "user://save/"

var _data := {
	"player0": {
		"character" : 0,
		"deaths" : 0,
		"total_score" : 0,
		"weapon" : 0
	},
	"player1": {
		"character" : 0,
		"deaths" : 0,
		"total_score" : 0,
		"weapon" : 0
	}
}

func _ready():
	Save(SAVE_PATH, 0)
	
func Save(path := SAVE_PATH, slot := 0):
	var dir = Directory.new()
	if !dir.dir_exists(path):
		dir.make_dir_recursive(path)
	
	var targetFile = path + "slot" + str(slot) + SAVE_FORMAT
	
	var file = File.new()
	var error = file.open(targetFile, File.WRITE)
	
	if error == OK: 
		file.store_var(_data)
		file.close()
	
func Load(path := SAVE_PATH, slot := 0):
	var targetFile = path + "slot" + str(slot) + SAVE_FORMAT
	
	var file = File.new()
	
	if file.file_exists(targetFile):
		var error = file.open(targetFile, File.READ)
		
		if error == OK:
			_data = file.get_var()
			file.close()
			
			return LOAD_SUCCESS
			
	return LOAD_ERROR_COULDNT_OPEN
	
func getData(category, key):
	return _data[category][key]
	
func setData(category, key, value):
	_data[category][key] = value
