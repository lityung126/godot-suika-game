extends Node

var config_file = ConfigFile.new();
var drop_item_config_array : Array = [];
var drop_rate_config_array : Array = [];
var score_section_array : Array = [];
var bgm_section_array : Array = [];
var sound_section_array : Array = [];

func _ready():
	print("1. 初始化表格")
	if GameManager.os_web:
		config_file.parse('''
[ui]
background="res://streaming_data/sprites/background.jpg"

;掉落道具貼圖, 順序代表成長方式
;名字=路徑
[drops]
drop_1="res://streaming_data/sprites/drops/1.png"
drop_2="res://streaming_data/sprites/drops/2.png"
drop_3="res://streaming_data/sprites/drops/3.png"
drop_4="res://streaming_data/sprites/drops/4.png"
drop_5="res://streaming_data/sprites/drops/5.png"
drop_6="res://streaming_data/sprites/drops/big_square.png"

;合併時會獲得的分數
; 1 3 6 10 15 21 28 36 45 55
[score]
drop_1=1
drop_2=3
drop_3=6
drop_4=10
drop_5=15


;掉落機率
[drop_rate]
drop_1=0.8
drop_2=0.2


[bgm]
maou_bgm_piano01="res://streaming_data/audio/bgm/maou_bgm_piano01.mp3"
maou_bgm_piano02="res://streaming_data/audio/bgm/maou_bgm_piano02.mp3"
maou_bgm_piano03="res://streaming_data/audio/bgm/maou_bgm_piano03.mp3"
maou_bgm_piano04="res://streaming_data/audio/bgm/maou_bgm_piano04.mp3"
maou_bgm_piano05="res://streaming_data/audio/bgm/maou_bgm_piano05.mp3"
maou_bgm_piano06="res://streaming_data/audio/bgm/maou_bgm_piano06.mp3"

[sound]
merge_sound="res://streaming_data/audio/sound/soundeffect_lab_confirm_42.mp3"
''')
	else :
		config_file.load("streaming_data/settings/config.ini")
		
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
