extends "../behaviour/basic_enemy_controller.gd"

export (int) var detectionLength = 1024
export (float) var idleTime = 1

var fell := false

func _ready():
	hitbox = $TipHitbox
	animator = $Animator
	applyGravity = false
	
	var _unused = connect("destroyed", self, "onDestruction")
	
func raycast(length := detectionLength, group := "Player"):
	var spaceState = get_world_2d().direct_space_state
	var result = spaceState.intersect_ray(position, position + Vector2(0, length), [self], collision_mask)
		
	if result:
		if result.collider.is_in_group(group):
			return true
		
	return false
	
func onBodyEntered(body):
	if fell:
		if body is Player and killsPlayer:
			body.takeDamage(damage)
			onDestruction()
	
func onDestruction():
	emit_signal("camera_shake_requested")
	Renderer.spawn4Piece(mainSprite)
	queue_free()
