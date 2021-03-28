extends Area2D

export (bool) var enabled = true
export (int) var levelToLoad = 0

func _ready():
	var _unused = connect("body_entered", self, "OnPlayerEnter")
	
func ChangeStatus(cond):
	call_deferred("ChangeHitbox", cond)

func ChangeHitbox(cond):
	$CollisionShape2D.disabled = cond

func OnPlayerEnter(body):
	if body is Player:
		Renderer.fade("in")
		Renderer.transition.connect("fade_finished", self, "_fadeEnd")
	
func _fadeEnd(_mode):
	Globals.LoadScene(levelToLoad)
