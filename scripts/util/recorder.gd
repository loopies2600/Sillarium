extends Node
class_name Recorder

const REPLAY_PATH = "res://data/autoplay/"

var actions := ["dash", "jump", "move_left", "move_right", "shoot", "aim_up", "aim_down", "aim_left", "aim_right"]
var pressed := [false, false, false, false, false, false, false, false, false]

var replayData := {
	0 : {
		"actions" : actions,
		"pressed" : pressed
	}
}
var frame := 0

func _physics_process(_delta):
	pressed = [Input.is_action_pressed(actions[0]), Input.is_action_pressed(actions[1]), Input.is_action_pressed(actions[2]), Input.is_action_pressed(actions[3]), Input.is_action_pressed(actions[4]), Input.is_action_pressed(actions[5]), Input.is_action_pressed(actions[6]), Input.is_action_pressed(actions[7]), Input.is_action_pressed(actions[8])]
	
	frame += 1
	replayData[frame] = {
	"actions": actions,
	"pressed": pressed
	}
	
func _input(event):
	if event.is_action_pressed("interact"):
		_saveReplay("test.tres")
		
func _saveReplay(fileName):
	var newRpl = Replay.new()
	newRpl.replayData = replayData
	ResourceSaver.save(REPLAY_PATH + fileName, newRpl)
