extends Position2D

onready var respawnTimer = $RespawnTimer
onready var respawnPos

var playerSlot

func _ready():
	respawnTimer.connect("timeout", self, "_respawnPlayer")
	
func _respawnPlayer():
	var player = Objects.spawnPlayer(0, respawnPos, true, playerSlot)
	queue_free()
