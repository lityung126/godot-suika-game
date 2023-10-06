extends Node

var drop_item_config_array : Array = [];
var drop_rate_config_array : Array = [];
var rng = RandomNumberGenerator.new()
var default_drop_name : String = "";
var next_drop_item_name : String = "";

signal event_on_next_drop_item_update();

func _ready():
	print("2. 初始化 掉落管理")
	drop_item_config_array = ConfigManager.drop_item_config_array
	drop_rate_config_array = ConfigManager.drop_rate_config_array
	next_drop_item_name = _random_next_drop_item_name();
	event_on_next_drop_item_update.emit()
	if drop_item_config_array.size() > 0:
		default_drop_name = drop_item_config_array[0].name

func get_drop_item_by_index(index : int) -> Node :
	for drop_item_config in drop_item_config_array:
		if drop_item_config.index == index:
			return generate_drop_item(drop_item_config)
	printerr("index drop_item_config not found : " , index)
	return null

func get_drop_item_by_name(drop_name : String) -> Node :
	for drop_item_config in drop_item_config_array:
		if drop_item_config.name == drop_name:
			return generate_drop_item(drop_item_config)
	printerr("name drop_item_config not found : " , drop_name)
	return null

func generate_drop_item(drop_item_config : DropItemConfig) -> Node:
	var inst = load("res://scenes/drop_item_template.tscn").instantiate()
	inst.set_script(load("res://scripts/game_scene/drop_item_template.gd"))
	var newDropItem = inst as DropItemTemplate
	newDropItem.add_texture(drop_item_config.image_path)
	newDropItem.add_poly_collider(drop_item_config.image_path)
	newDropItem.index = drop_item_config.index;
	newDropItem.drop_name = drop_item_config.name;
	return inst

func _random_next_drop_item_name() -> String:
	var rand_float = rng.randf()
	var current_rate : float = 0
	for drop_rate_config in drop_rate_config_array :
		current_rate = current_rate + drop_rate_config.drop_rate
		if current_rate > 1:
			print("機率超過1了")
		if rand_float <= current_rate:
			return drop_rate_config.name
	# 若都沒有 丟第一個出去
	# print("機率不到1 所以random ")
	return default_drop_name
	

func get_random_drop_item() -> Node:
	var drop_item_name = next_drop_item_name
	next_drop_item_name = _random_next_drop_item_name();
	event_on_next_drop_item_update.emit()
	return get_drop_item_by_name(drop_item_name)
