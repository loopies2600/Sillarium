extends Sprite

func _ready():
	$AnimationPlayer.play("FadeOut")

func DestroySelf():
	queue_free()
