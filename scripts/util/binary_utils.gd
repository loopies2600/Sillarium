extends Object
class_name BinaryUtils

static func dec2bin(var decimalValue : int) -> int:
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
	
static func bin2dec(var binaryValue : int) -> int:
	var decimalValue = 0
	var count = 0
	var temp
	while(binaryValue != 0):
		temp = binaryValue % 10
		binaryValue /= 10
		decimalValue += temp * pow(2, count)
		count += 1
	return decimalValue
