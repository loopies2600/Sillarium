extends Node

enum {LOAD_SUCCESS, LOAD_ERROR_COULDNT_OPEN}

const SAVE_FORMAT = ".sillarium"
const SAVE_PATH = "user://save/"

var _data := {
	"player": {
		"character" : 0,
		"lives" : 4,
		"deaths" : 0,
		"total_score" : 0,
		"weapon" : 0
	},
	"playerTwo": {
		"character" : 0,
		"lives" : 4,
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
	
func getFileList(path := SAVE_PATH, exclude := []):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin(true, true)
	
	while true:
		var file = dir.get_next()
		
		if file == "":
			break
		elif not file.begins_with("."):
			for prefix in exclude:
				if not file.begins_with(prefix):
					files.append(file)
			
	dir.list_dir_end()
	
	return files
