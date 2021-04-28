extends Node
class_name AutoPlayer

const REPLAY_PATH = "res://data/autoplay/"

var replayData = load(REPLAY_PATH + "test.tres").replayData

var frame := 0
var lastFrame := 64
var updateRate := 0.1

func _ready():
	_frameUpdate()
	
func _frameUpdate():
	yield(get_tree().create_timer(updateRate), "timeout")
	frame = clamp(frame + 1, 0, lastFrame)
	_frameUpdate()
	
func _process(_delta):
	if replayData.has(frame):
		for act in replayData[frame]["actions"].size():
			var a = InputEventAction.new()
			a.action = replayData[frame].actions[act]
			a.pressed = replayData[frame].pressed[act]
			Input.parse_input_event(a)
