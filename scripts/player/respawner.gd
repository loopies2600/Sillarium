extends Position2D

signal player_respawned

onready var respawnTimer = $RespawnTimer
onready var respawnPos

func _ready():
	respawnTimer.connect("timeout", self, "_respawnPlayer")
	
func _respawnPlayer():
	Objects.spawnPlayer(0, respawnPos, self)
	emit_signal("player_respawned")
	queue_free()
