extends Position2D

onready var respawnTimer = $RespawnTimer

func _ready():
	respawnTimer.connect("timeout", self, "_respawnPlayer")
	
func _respawnPlayer():
	Objects.playerInit(0, Objects.currentWorld.startPos)
	queue_free()
