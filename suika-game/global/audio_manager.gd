extends Node

var bgm_audio_player : AudioStreamPlayer
var sound_audio_players : Array = []

var merge_sound : AudioStream
var bgm_list : Array = []

var rng = RandomNumberGenerator.new()

var master_volume : float = 0.5;
var bgm_volume : float = 0.5;
var fx_volume : float = 0.5;

func set_master_volume(value :float):
	master_volume = value
	bgm_audio_player.set_volume_db(linear_to_db(master_volume * bgm_volume))

	
func set_bgm_volume(value :float):
	bgm_volume = value
	bgm_audio_player.set_volume_db(linear_to_db(master_volume * bgm_volume))
	
	
func set_fx_volume(value :float):
	fx_volume = value

func _ready():
	
	
	bgm_audio_player = _generate_idle_audio_stream_player()
	bgm_audio_player.name = "bgm_audio_player"
	bgm_audio_player.set_volume_db(linear_to_db(master_volume * bgm_volume))
	
	for bgm_config in ConfigManager.bgm_section_array:
		var file_path = bgm_config.path;
		var stream = _generate_audio_stream(file_path);
		if not stream == null:
			bgm_list.push_back(stream)
	
	for sound_config in ConfigManager.sound_section_array:
		if sound_config.name == "merge_sound":
			merge_sound = _generate_audio_stream(sound_config.path)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if bgm_list.size() > 0:
		if not bgm_audio_player.playing:
			_play_random_BGM()

func _play_random_BGM():
	if bgm_list.size() == 0:
		print ("no bgm");
		return;
	var index = rng.randi_range(0, bgm_list.size() - 1)
	bgm_audio_player.stream = bgm_list[index]
	bgm_audio_player.play()

func play_merge_sound() :
	var sp = _find_idle_sound_player();
	sp.set_volume_db(linear_to_db(master_volume * fx_volume))
	sp.stream = merge_sound;
	sp.play()

func _find_idle_sound_player() -> AudioStreamPlayer:
	for sap in sound_audio_players:
		if not sap.playing:
			return sap
	var newSAP = _generate_idle_audio_stream_player();
	newSAP.name = "sound_audio_player"
	sound_audio_players.push_back(newSAP)
	return newSAP

func _generate_idle_audio_stream_player() -> AudioStreamPlayer:
	var ap = AudioStreamPlayer.new();
	add_child(ap)
	return ap

func _generate_audio_stream(path : String) -> AudioStream:
	if GameManager.os_web:
		return load(path)
	else :
		var extension = path.get_extension()
		extension = extension.to_lower()
		match extension:
			"mp3":
				return _load_mp3(path)
			"ogg":
				return _load_ogg(path)
			"wav":
				return _load_wav(path)
			_:
				print("not support format " , extension)
				return null
	
func _load_mp3(path) -> AudioStream:
	
	var mp3_file = FileAccess.open(path, FileAccess.READ)
	var stream = AudioStreamMP3.new()
	stream.data = mp3_file.get_buffer(mp3_file.get_length())
	return stream

func _load_wav(path) -> AudioStream:
	var wav_file  = FileAccess.open(path, FileAccess.READ)
	var stream = AudioStreamWAV.new()
	stream.data = wav_file.get_buffer(wav_file.get_length())
	return stream

func _load_ogg(path) -> AudioStream:
	var ogg_file = FileAccess.open(path, FileAccess.READ)
	var stream : AudioStreamOggVorbis = AudioStreamOggVorbis.new()
	var packet : OggPacketSequence = OggPacketSequence.new()
	packet.packet_data = ogg_file.get_buffer(ogg_file.get_length())
	stream.packet_sequence = packet
	return stream
