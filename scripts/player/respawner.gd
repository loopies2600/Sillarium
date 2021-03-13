extends Position2D

onready var respawnTimer = $RespawnTimer
onready var respawnPos

func _ready():
	respawnTimer.connect("timeout", self, "_respawnPlayer")
	
func _respawnPlayer():
	var player = Objects.spawnPlayer(0, respawnPos, true)
	queue_free()
