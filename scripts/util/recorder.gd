extends Node
class_name Recorder

const REPLAY_PATH = "res://data/autoplay/"

var actions := ["dash", "jump", "move_left", "move_right", "shoot"]
var pressed := [false, false, false, false, false]

var replayData := {
	0 : {
		"actions" : actions,
		"pressed" : pressed
	}
}
var frame := 0
var updateRate := 0.1

func _ready():
	_frameUpdate()
	
func _frameUpdate():
	yield(get_tree().create_timer(updateRate), "timeout")
	frame += 1
	replayData[frame] = {
	"actions": actions,
	"pressed": pressed
	}
	_frameUpdate()
	
func _physics_process(_delta):
	pressed = [Input.is_action_pressed(actions[0]), Input.is_action_pressed(actions[1]), Input.is_action_pressed(actions[2]), Input.is_action_pressed(actions[3]), Input.is_action_pressed(actions[4])]
	
	if Input.is_action_just_pressed("interact"):
		_saveReplay("test.tres")
	
func _saveReplay(fileName):
	var newRpl = Replay.new()
	newRpl.replayData = replayData
	ResourceSaver.save(REPLAY_PATH + fileName, newRpl)
