extends CanvasLayer

onready var BG = $ColorBG
onready var label = $PauseText
onready var music = $CoolPauseMusic
onready var anim = $Animator

func _ready():
	if !Audio.mute:
		music.play()
		
	label.bbcode_text = "[wave]" + tr("PAUSED")
		
func _process(_delta):
	if get_tree().paused:
		music.volume_db = lerp(music.volume_db, -10.0, 0.0125)
	else:
		music.volume_db = -80
		
func _input(event):
	if event.is_action_pressed("pause"):
		if !get_tree().paused:
			get_tree().paused = !get_tree().paused
			anim.play("In")
			BG.visible = !BG.visible
			label.visible = !label.visible
		else:
			get_tree().paused = !get_tree().paused
			anim.play("Out")
			yield(anim, "animation_finished")
			BG.visible = !BG.visible
			label.visible = !label.visible
