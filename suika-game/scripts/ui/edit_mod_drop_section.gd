extends VBoxContainer

var _config_file : ConfigFile
var drop_section_prefab = preload("res://scenes/edit_mod_ui_drop_item_h_box_container.tscn")

var drop_data_dict : Dictionary
@onready var edit_drop_item_control = $"../../../../EditDropItemControl"
@onready var select_drop_item_control = $"../../../../SelectDropItemControl"
@onready var edit_drop_item_file_dialog = $EditDropItemFileDialog
@onready var scroll_container : ScrollContainer = $"../.."
var v_scroll_bar : VScrollBar

@onready var add_drop_button = $Title/HBoxContainer/AddDropButton

signal evt_on_config_modify()

# Called when the node enters the scene tree for the first time.
func _ready():
	v_scroll_bar = scroll_container.get_v_scroll_bar()
	add_drop_button.button_up.connect(_on_button_up_click)
	select_drop_item_control.on_drop_item_created.connect(_on_drop_item_created)
	edit_drop_item_control.on_drop_item_edit_end.connect(_on_drop_item_edit_end)

func set_data(config_file):
	self._config_file = config_file
	for items in drop_data_dict.values():
		self.remove_child(items.item)
		items.item.queue_free()
		
	drop_data_dict.clear()
	
	var drops_section_name = "drops" # name : path
	var drops_section_name_keys = config_file.get_section_keys(drops_section_name)
	for k in drops_section_name_keys:
		var value = config_file.get_value(drops_section_name, k)
		if not drop_data_dict.has(k) :
			drop_data_dict[k] = DropData.new()
			drop_data_dict[k].name = k;
		drop_data_dict[k].path = value
	
	var drop_rate_section_name = "drop_rate" # name : drop_rate
	var drop_rate_section_name_keys = config_file.get_section_keys(drop_rate_section_name)
	for k in drop_rate_section_name_keys:
		var value = config_file.get_value(drop_rate_section_name, k)
		if not drop_data_dict.has(k) :
			drop_data_dict[k] = DropData.new()
			drop_data_dict[k].name = k;
		drop_data_dict[k].drop_rate = value
		
	var score_section_name = "score" # name : score
	var score_section_name_keys = config_file.get_section_keys(score_section_name)
	for k in score_section_name_keys:
		var value = config_file.get_value(score_section_name, k)
		if not drop_data_dict.has(k) :
			drop_data_dict[k] = DropData.new()
			drop_data_dict[k].name = k;
		drop_data_dict[k].score = value
	
	for drop_data in drop_data_dict.values():
		var drop_section_item = drop_section_prefab.instantiate()
		drop_section_item.evt_on_delete_click.connect(on_item_delete_click);
		drop_section_item.evt_on_edit_click.connect(on_item_edit_click);
		drop_data.item = drop_section_item
		self.add_child(drop_section_item)
		drop_section_item.set_data(drop_data)

func _on_button_up_click():
	if not add_drop_button.is_hovered():
		return
	select_drop_item_control.visible = true
	pass

func _on_drop_item_created(path, drop_name, drop_score, drop_rate):
	for drop_data in drop_data_dict.values():
		if drop_data.name == drop_name:
			printerr ("name duplicate!!")
			return
	_config_file.set_value("drops", drop_name, path)
	_config_file.set_value("drop_rate", drop_name, drop_rate)
	_config_file.set_value("score", drop_name, drop_score)
	evt_on_config_modify.emit()
	set_data(_config_file)
	
	v_scroll_bar.changed.connect(scroll_to_end, Object.CONNECT_ONE_SHOT)
	
	

func scroll_to_end():
	scroll_container.scroll_vertical = scroll_container.get_v_scroll_bar().max_value
	pass

func _on_drop_item_edit_end(node, path, drop_name, drop_score, drop_rate):
	edit_drop_item_control.visible = true
	for drop_data in drop_data_dict.values():
		if drop_data.item == node:
			drop_data.path = path;
			drop_data.score = drop_score;
			drop_data.drop_rate = drop_rate
			node.set_data(drop_data)
			_config_file.set_value("drops", drop_name, path)
			_config_file.set_value("drop_rate", drop_name, drop_rate)
			_config_file.set_value("score", drop_name, drop_score)
			evt_on_config_modify.emit()
			set_data(_config_file)
	edit_drop_item_control.visible = false
	

func on_item_delete_click(drop_name : String):
	for drop_data in drop_data_dict.values():
		if drop_data.name == drop_name:
			try_erase_section_key("drops", drop_name)
			try_erase_section_key("drop_rate", drop_name)
			try_erase_section_key("score", drop_name)
			set_data(_config_file)
			return
	printerr ("name not found")

func try_erase_section_key(section, key):
	if _config_file.has_section_key(section, key):
		_config_file.erase_section_key(section, key)

func on_item_edit_click(sender, drop_name, path, score, rate):
	edit_drop_item_control.set_data(sender, drop_name, path, score, rate)
	edit_drop_item_control.visible = true

class DropData:
	var name: String
	var path: String
	var drop_rate : float
	var score : int
	var item : Node
	

