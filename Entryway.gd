extends Area2D

export (bool) var enabled = true
export (String) var levelToLoad = "SalaGraciosa"

func _ready():
	connect("body_entered", self, "OnPlayerEnter")

func ChangeStatus(cond):
	call_deferred("ChangeHitbox", cond)

func ChangeHitbox(cond):
	$CollisionShape2D.disabled = cond

func OnPlayerEnter(body):
	Globals.LoadLevel(levelToLoad)
