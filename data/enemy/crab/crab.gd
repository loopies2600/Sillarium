extends KinematicBody2D

onready var fireTimer = $FireTimer
onready var renderer = $Graphics
onready var animator = $Animations
onready var spikes = [$Graphics/Top/SpikeLeft, $Graphics/Top/SpikeTop, $Graphics/Top/SpikeRight]
onready var spikesPos = [spikes[0].position, spikes[1].position, spikes[2].position]

var spikesSpeed = 800
var hasSpikes = true

export (PackedScene) var spike

func _ready():
	fireTimer.connect("timeout", self, "_onTimeout")
	fireTimer.start()
	
func _onTimeout():
	if hasSpikes:
		animator.play("AttackPrepare")
		yield(animator, "animation_finished")
		animator.play("Attack")
		yield(animator, "animation_finished")
		animator.play("Idle")
	
func _fire():
	for s in range(3):
		var newSpike = spike.instance()
		
		newSpike.position = spikesPos[s]
		newSpike.rotation = spikes[s].rotation
		newSpike.speed = Vector2(0.0, -spikesSpeed)
		
		add_child(newSpike)
		
		newSpike.sprite.texture = spikes[s].texture
		
		spikes[s].queue_free()
		
		hasSpikes = false
