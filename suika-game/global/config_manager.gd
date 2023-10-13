extends Node

var config_file = ConfigFile.new();
var drop_item_config_array : Array = [];
var drop_rate_config_array : Array = [];
var score_section_array : Array = [];
var bgm_section_array : Array = [];
var sound_section_array : Array = [];
var player_config : PlayerConfig;

func _ready():
	print("1. 初始化表格")
	var path = "streaming_data/settings/config.ini";
	if GameManager.os_web:
		path = "res://" + path
		
	var file = FileAccess.open(path, FileAccess.READ);
	var content = file.get_as_text();
	config_file.parse(content)
	file.close();

	_init_player_section();
	_init_drops_section();
	_init_drop_rate_section();
	_init_bgm_section();
	_init_sound_section();
	_init_score_section();

# 取得背景路徑
func get_background_path() -> String :
	if not config_file.has_section_key("ui", "background"):
		return "";
	var background = config_file.get_value("ui", "background")
	return background

func get_menu_background_path() -> String :
	if not config_file.has_section_key("ui", "menu_background"):
		return "";
	var background = config_file.get_value("ui", "menu_background")
	return background

func _init_player_section():
	var section_name = "player";
	var image_path = config_file.get_value(section_name, "player_image_path")
	var offset_x = config_file.get_value(section_name, "offset_x")
	var offset_y = config_file.get_value(section_name, "offset_y")
	player_config = PlayerConfig.new(image_path, offset_x, offset_y)


# 取得掉落道具設定
func _init_drops_section():
	var section_name = "drops";
	var keys = config_file.get_section_keys(section_name)
	var index = 0;
	for k in keys:
		var value = config_file.get_value(section_name, k)
		drop_item_config_array.push_back(DropItemConfig.new(index, k, value))
		print ("drop_item_config_array push %d %s %s" % [index, k, value])
		index = index + 1
	

func _init_drop_rate_section():
	var section_name = "drop_rate";
	var keys = config_file.get_section_keys(section_name)
	var index = 0;
	for k in keys:
		var value = config_file.get_value(section_name, k)
		drop_rate_config_array.push_back(DropRateConfig.new(index,k, value))
		print ("drop_item_config_array push %s %f" % [k, value])
		index = index + 1
	

func _init_bgm_section():
	var section_name = "bgm";
	var keys = config_file.get_section_keys(section_name)
	
	for k in keys:
		var value = config_file.get_value(section_name, k)
		bgm_section_array.push_back(BGMConfig.new(k, value))
		print ("bgm_section_array push %s %s" % [k, value])
	

func _init_sound_section():
	var section_name = "sound";
	var keys = config_file.get_section_keys(section_name)
	
	for k in keys:
		var value = config_file.get_value(section_name, k)
		sound_section_array.push_back(SoundConfig.new(k, value))
		print ("sound_section_array push %s %s" % [k, value])

func _init_score_section():
	var section_name = "score"
	var keys = config_file.get_section_keys(section_name)
	
	for k in keys:
		var value = config_file.get_value(section_name, k)
		score_section_array.push_back(ScoreConfig.new(k, value))
		print ("score_section_array push %s %s" % [k, value])
	pass
