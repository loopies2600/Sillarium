extends Kinematos

export (int) var detectionLength = 1024
export (float) var idleTime = 1

var fell := false

func _ready():
	animator = $Animator
	applyGravity = false
	
func raycast(length := detectionLength, group := "Player"):
	var spaceState = get_world_2d().direct_space_state
	var result = spaceState.intersect_ray(position, position + Vector2(0, length), [self], collision_mask)
		
	if result:
		if result.collider.is_in_group(group):
			return true
		
	return false
