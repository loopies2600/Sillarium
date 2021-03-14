extends KinematicBody2D
class_name Kinematos

func setCollisionBits(bitArray := [], booly := true):
	for bit in bitArray:
		set_collision_mask_bit(bit, booly)

func keepOnScreen(clampX := false, clampY := false):
	var ctrans = get_canvas_transform()

	var minPos = -ctrans.get_origin() / ctrans.get_scale()

	var viewSize = get_viewport_rect().size / ctrans.get_scale()
	var maxPos = minPos + viewSize
	
	if clampX:
		global_position.x = clamp(global_position.x, minPos.x, maxPos.x)
	if clampY:
		global_position.y = clamp(global_position.y, minPos.y, maxPos.y)

func getShaderParam(parameter : String):
	var material = self.get_material()
	return material.get_shader_param(parameter)
