extends KinematicBody2D
class_name Kinematos

# warning-ignore:unused_signal
signal camera_shake_requested(mode, time, amp)

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

func getStandingTile(feetPos, tileMap := Objects.currentWorld.tileMap):
	var curTilePos = tileMap.world_to_map(feetPos)
	var curTile = tileMap.get_cellv(Vector2(curTilePos.x, curTilePos.y + 1))
	
	return curTile
	
func getShaderParam(parameter : String):
	var material = self.get_material()
	return material.get_shader_param(parameter)
