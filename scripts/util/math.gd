extends Object
class_name Math

static func isEven(value : int) -> bool:
	return value % 2 == 0
	
static func dec2bin(decimalValue : int) -> int:
	var binaryString = "" 
	var temp 
	var count = 31
	while(count >= 0):
		temp = decimalValue >> count 
		if(temp & 1):
			binaryString = binaryString + "1"
		else:
			binaryString = binaryString + "0"
		count -= 1
		
	return int(binaryString)
	
static func bin2dec(binaryValue : int) -> int:
	var decimalValue = 0
	var count = 0
	var temp
	while(binaryValue != 0):
		temp = binaryValue % 10
		binaryValue /= 10
		decimalValue += temp * pow(2, count)
		count += 1
	return decimalValue
	
static func isBitEnabled(mask, index):
	return mask & (1 << index) != 0
	
static func setBit(mask, index, enabled := true):
	if enabled:
		return mask | (1 << index)
	else:
		return mask & ~(1 << index)
	
static func remapToRange(value : float, iStart : float, iStop : float, oStart : float, oStop : float) -> float:
	return oStart + (oStop - oStart) * ((value - iStart) / (iStop - iStart))
	
static func toVec2(value) -> Vector2:
	return Vector2(value, value)
	
static func toVec3(value) -> Vector3:
	return Vector3(value, value, value)

static func calculateAngleIndex(radians, anglePerDirection = TAU / 8):
	var angleStep = stepify(radians, anglePerDirection)
	angleStep = fposmod(angleStep, TAU)
	
	return int(angleStep / anglePerDirection)
