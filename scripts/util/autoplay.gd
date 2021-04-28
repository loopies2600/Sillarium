extends Node
class_name AutoPlayer

const REPLAY_PATH = "res://data/autoplay/"

var replayData = load(REPLAY_PATH + "test.tres").replayData

var frame := 0
var lastFrame := 0

func _ready():
	lastFrame = int(replayData.keys()[replayData.size() - 1])
	
func _physics_process(_delta):
	if replayData.has(frame):
		for act in replayData[frame]["actions"].size():
			var a = InputEventAction.new()
			a.action = replayData[frame]["actions"][act]
			a.pressed = replayData[frame]["pressed"][act]
			Input.parse_input_event(a)
	
	frame = clamp(frame + 1, 0, lastFrame)
