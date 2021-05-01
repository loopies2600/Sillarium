extends KinematicBody2D
class_name Kinematos

var velocity := Vector2()
# warning-ignore:unused_signal
signal camera_shake_requested(mode, time, amp)

func checkPushables(vel = velocity.x):
	var isOnEnvironment = false
	var pushable
	
	for b in get_slide_count():
		var body = get_slide_collision(b).collider
		
		if body:
			if body.is_in_group("Pushable"):
				pushable = body
			elif body.is_in_group("Environment"):
				isOnEnvironment = true
			
	if isOnEnvironment && pushable:
		pushable.Push(vel)
		
func setCollisionBits(bitArray := [], booly := true):
	for bit in bitArray:
		set_collision_mask_bit(bit, booly)

func keepOnScreen(clampX := true, clampY := false, offset := Vector2()):
	var ctrans = get_canvas_transform()

	var minPos = -ctrans.get_origin() / ctrans.get_scale()

	var viewSize = get_viewport_rect().size / ctrans.get_scale()
	var maxPos = minPos + viewSize
	
	if clampX:
		global_position.x = clamp(global_position.x, minPos.x + offset.x, maxPos.x - offset.x)
	if clampY:
		global_position.y = clamp(global_position.y, minPos.y + offset.y, maxPos.y - offset.y)

func placeOutOfScreen(side := -1, offset := 128):
	var ctrans = get_canvas_transform()
	
	var minPos = -ctrans.get_origin() / ctrans.get_scale()
	
	var viewSize = get_viewport_rect().size / ctrans.get_scale()
	
	var maxPos = minPos + (viewSize / 2)
	
	global_position.x = (maxPos.x * side) + (offset * side)
	
func getStandingTile(feetPos, tileMap := Objects.currentWorld.tileMap):
	var curTilePos = tileMap.world_to_map(feetPos)
	var curTile = tileMap.get_cellv(Vector2(curTilePos.x, curTilePos.y + 1))
	
	return curTile
	
func getShaderParam(parameter : String):
	var material = self.get_material()
	return material.get_shader_param(parameter)
	
func setupProperties(res : Resource, pStart := 8, pEnd := 0):
	var resPCount = res.get_property_list().size()
	
	for v in range(pStart, resPCount if pEnd == 0 else pEnd):
		var curP = res.get_property_list()[v].name
		
		set(curP, res.get(curP))
