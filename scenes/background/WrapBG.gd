extends TextureRect

var offsetLimit = texture.get_size()
export var speed = 2;

func _ready():
	rect_size = rect_size + (offsetLimit * 2)
	
func _process(delta):
	rect_position -= Vector2(speed, speed)
	
	if (abs(rect_position.x) >= offsetLimit.x):
		rect_position.x = 0;
		
	if (abs(rect_position.y) >= offsetLimit.y):
		rect_position.y = 0;
