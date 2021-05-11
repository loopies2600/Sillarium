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
	
static func getOGG(bgmID, json = Audio.MUSIC):
	var path = Globals.LoadJSON(json, bgmID, "file")
	var oggFile = File.new()
	oggFile.open(path, File.READ)
	var bytes = oggFile.get_buffer(oggFile.get_len())
	var stream = AudioStreamOGGVorbis.new()
	stream.data = bytes
	stream.loop = Globals.LoadJSON(json, bgmID, "loop")
	stream.loop_offset = float(Globals.LoadJSON(json, bgmID, "loop_offset"))
	oggFile.close()
	
	return stream
	
static func getWAV(sfxID, json = Audio.SOUND):
	var path = Globals.LoadJSON(json, sfxID, "file")
	var wavFile = File.new()
	wavFile.open(path, File.READ)
	var bytes = wavFile.get_buffer(wavFile.get_len() - Audio.WAV_PADDING)
	wavFile.close()
	
	for i in range(Audio.WAV_PADDING):
		bytes[i] = 0
		
	var stream = AudioStreamSample.new()
	
	stream.format = Globals.LoadJSON(json, sfxID, "format")
	stream.mix_rate = Globals.LoadJSON(json, sfxID, "sample_rate")
	stream.stereo = Globals.LoadJSON(json, sfxID, "stereo")
	stream.data = bytes
	
	return stream
