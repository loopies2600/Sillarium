extends KinematicBody2D
class_name Kinematos

func setCollisionBits(bitArray := [], booly := true):
	for bit in bitArray:
		set_collision_mask_bit(bit, booly)
