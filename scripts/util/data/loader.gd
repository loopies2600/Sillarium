extends Object
class_name Loader

static func getTexture(path, flags := 0):
	if OS.is_debug_build():
		path = path.replace("res://", "user://")
	else:
		path = path.replace("res://", "")
		
	var file = File.new()
	
	file.open(path, File.READ)
	
	var image = Image.new()
	image.load_png_from_buffer(file.get_buffer(file.get_len()))
	
	file.close()
	image.lock()
	
	var texture = ImageTexture.new()
	texture.create_from_image(image, flags)
	
	return texture
	
static func getOGG(bgmID, path = Audio.MUSIC):
	var resource = load(path + "%s.tres" % bgmID)
	var stream = AudioStreamOGGVorbis.new()
	
	if OS.get_name() == "HTML5":
		stream = load(resource.file)
	else:
		var oggFile = File.new()
		oggFile.open(resource.file, File.READ)
		var bytes = oggFile.get_buffer(oggFile.get_len())
		stream.data = bytes
		stream.loop = resource.loop
		stream.loop_offset = resource.loopOffset
		oggFile.close()
	
	return stream
	
static func getWAV(sfxID, path = Audio.SOUND):
	var resource = load(path + "%s.tres" % sfxID)
	var stream = AudioStreamSample.new()
	
	if OS.get_name() == "HTML5":
		stream = load(resource.file)
	else:
		var wavFile = File.new()
		wavFile.open(resource.file, File.READ)
		var bytes = wavFile.get_buffer(wavFile.get_len() - Audio.WAV_PADDING)
		wavFile.close()
		
		for i in range(Audio.WAV_PADDING):
			bytes[i] = 0
		
		stream.format = resource.format
		stream.mix_rate = resource.sampleRate
		stream.stereo = resource.stereo
		stream.data = bytes
	
	return stream
