extends Area2D

export (bool) var enabled = true
export (String) var levelToLoad = "SalaGraciosa"

func _ready():
	var _unused = connect("body_entered", self, "OnPlayerEnter")
	
func ChangeStatus(cond):
	call_deferred("ChangeHitbox", cond)

func ChangeHitbox(cond):
	$CollisionShape2D.disabled = cond

func OnPlayerEnter(_body):
	Globals.fade("in")
	Globals.transition.connect("fade_finished", self, "_fadeEnd")
	
func _fadeEnd():
	Globals.LoadLevel(levelToLoad)
