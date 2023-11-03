extends Control

@onready var v_box_container = $ColorRect/ScrollContainer/VBoxContainer
@onready var mod_item_prefab = preload("res://scenes/mod_item.tscn");

@onready var delete_button = $ColorRect/RightBotHBoxContainer/DeleteButton
@onready var create_button = $ColorRect/LeftBotHBoxContainer/CreateButton
@onready var edit_button = $ColorRect/RightBotHBoxContainer/EditButton
@onready var active_button = $ColorRect/RightBotHBoxContainer/ActiveButton
@onready var rename_button = $ColorRect/RightBotHBoxContainer/RenameButton

@onready var import_button = $ColorRect/LeftBotHBoxContainer/ImportButton
@onready var export_button = $ColorRect/RightBotHBoxContainer/ExportButton

@onready var close_button = $ColorRect/CloseButton

@onready var current_mod_label = $ColorRect/LeftTopHBoxContainer/CurrentModLabel

@onready var import_file_dialog = $ImportFileDialog
@onready var export_file_dialog = $ExportFileDialog

@onready var rename_ui = $RenameUI

signal on_mod_changed

var mod_path = "streaming_data/mods";

var DEFAULT_MOD_NAME = "default"
var CANT_DELETE_MOD = "default"

var ui_select_mode_name = "default"

# Called when the node enters the scene tree for the first time.
func _ready():
	delete_button.button_up.connect(_on_delete_click)
	create_button.button_up.connect(_on_create_click)
	edit_button.button_up.connect(_on_edit_click)
	active_button.button_up.connect(_on_active_click)
	rename_button.button_up.connect(_on_rename_click)
	
	import_button.button_up.connect(_on_import_click)
	export_button.button_up.connect(_on_export_click)
	
	close_button.button_up.connect(_on_close_button_click)
	
	import_file_dialog.file_selected.connect(_on_import_file_dialog_file_selected);
	export_file_dialog.file_selected.connect(_on_export_file_dialog_file_selected);
	
	rename_ui.evt_on_rename_click.connect(_evt_on_rename_click_callback)
	
	if GameManager.os_web:
		mod_path = "res://" + mod_path
	_update_mod_list()
	
	current_mod_label.text = GameManager.mod_name

func _update_mod_list():
	# clear container
	for n in v_box_container.get_children():
		v_box_container.remove_child(n)
		n.queue_free()
	# sacn mod folder
	var dir = DirAccess.open(mod_path)
	var files = dir.get_files()
	# create
	for file in files:
		print(file)
		var item = mod_item_prefab.instantiate()
		v_box_container.add_child(item)
		if file.ends_with(".ini"):
			var file_name = file.trim_suffix(".ini");
			item.text = file_name
			item.name = file_name
			var on_click_event = func(): _on_mod_item_click(item)
			item.button_up.connect(on_click_event)
		
	_set_none_select_button()

func _set_none_select_button():
	delete_button.visible = false
	create_button.visible = true
	edit_button.visible = false
	active_button.visible = false
	export_button.visible = false
	rename_button.visible = false

func _on_mod_item_click(sender):
	if not sender.is_hovered():
		return
		
	ui_select_mode_name = sender.name
	
	delete_button.visible = ui_select_mode_name != CANT_DELETE_MOD
	edit_button.visible = ui_select_mode_name != CANT_DELETE_MOD
	export_button.visible = ui_select_mode_name != CANT_DELETE_MOD
	active_button.visible = _check_mod_can_use(ui_select_mode_name)
	rename_button.visible = ui_select_mode_name != CANT_DELETE_MOD

func _on_delete_click():
	if not delete_button.is_hovered():
		return
	print("delete click")
	var dir = DirAccess.open(mod_path)
	dir.remove(ui_select_mode_name + ".ini")
	if GameManager.mod_name == ui_select_mode_name:
		GameManager.mod_name = DEFAULT_MOD_NAME
		current_mod_label.text = GameManager.mod_name
	ui_select_mode_name = DEFAULT_MOD_NAME
	_update_mod_list()

func _on_create_click():
	if not create_button.is_hovered():
		return;
	var dir = DirAccess.open(mod_path)
	var reference_file_name = DEFAULT_MOD_NAME
	var index : int = 1;
	while(dir.file_exists(reference_file_name + str(index) + ".ini")):
		index = index + 1
	var new_file_name = reference_file_name + str(index) + ".ini";
	print("try copy " + reference_file_name + ".ini" + " to " + new_file_name)
	var err = dir.copy(mod_path+ "/" + reference_file_name + ".ini", mod_path+ "/" +new_file_name)
	if err != OK:
		printerr("copy fail : " + error_string(err))
	_update_mod_list()

func _on_active_click():
	if not active_button.is_hovered():
		return
	GameManager.mod_name = ui_select_mode_name
	current_mod_label.text = GameManager.mod_name
	
	on_mod_changed.emit()

func _on_rename_click():
	if not rename_button.is_hovered():
		return
	rename_ui.visible = true

func _on_import_click():
	if not import_button.is_hovered():
		return
	import_file_dialog.visible = true

func _on_export_click():
	if not export_button.is_hovered():
		return
	export_file_dialog.visible = true

func _on_edit_click():
	if not edit_button.is_hovered():
		return
	var editModUI = UIManagerCanvas.show_ui(UIManager.UI_NAMES.EditModUI)
	editModUI.edit_mod(ui_select_mode_name)
	

func _on_close_button_click():
	if not close_button.is_hovered():
		return
	UIManagerCanvas.hide_ui(UIManager.UI_NAMES.ModUI);

func _on_import_file_dialog_file_selected(file_path:String):
	var zipReader = ZIPReader.new()
	zipReader.open(file_path)
	var zip_file_paths = zipReader.get_files()
	for zip_file_path in zip_file_paths:
		var file_buffer = zipReader.read_file(zip_file_path)
		# print("now zip file : " + zip_file_path)
		var dir = DirAccess.open(".");
		var base_dir = zip_file_path.get_base_dir();
		# print("try create : " + base_dir)
		var prefix_path = ""
		if base_dir.is_empty():
			prefix_path = "streaming_data/mods/"
		else:
			prefix_path = "streaming_data/"
		
		dir.make_dir_recursive(prefix_path + base_dir)
		var file = FileAccess.open(prefix_path + zip_file_path, FileAccess.WRITE)
		file.store_buffer(file_buffer)
		OS.shell_open(str("file://", file))

		file.close();
	_update_mod_list();
	import_file_dialog.visible = false
	

func _on_export_file_dialog_file_selected(_file_path:String):
	var file_path = _file_path
	var config_path = mod_path + "/" + ui_select_mode_name + ".ini"
	var config_ini_file = FileAccess.open(config_path, FileAccess.READ);
	
	var config_file = ConfigFile.new()
	config_file.parse(config_ini_file.get_as_text())
	
	if not file_path.ends_with(".skmod"):
		file_path = file_path + ".skmod"
	
	var zip_writer = ZIPPacker.new()
	
	zip_writer.open(file_path, ZIPPacker.APPEND_CREATE)
	
	# section move and modify name
	# section : player 
	_change_config_and_zip(zip_writer, config_file, "player", "player_image_path")
	
	# section : drops 
	_change_config_and_zip_by_section(zip_writer, config_file, "drops")
	
	
	# not a path comment
	# section : score 
	# var score_keys = config_file.get_section_keys("score")
	# section : drop_rate 
	# var drop_rate_keys = config_file.get_section_keys("drop_rate")
	
	# section : bgm 
	_change_config_and_zip_by_section(zip_writer, config_file, "bgm")
	
	# section : sound 
	_change_config_and_zip(zip_writer, config_file, "sound", "merge_sound")
	
	# section : ui
	_change_config_and_zip(zip_writer, config_file, "ui", "menu_background")
	_change_config_and_zip(zip_writer, config_file, "ui", "background")
	
	zip_writer.start_file(ui_select_mode_name + ".ini")
	zip_writer.write_file(config_file.encode_to_text().to_utf8_buffer())
	zip_writer.close_file()
	
	config_ini_file.close()

func _change_config_and_zip_by_section(zip_writer, config_file, section):
	var keys = config_file.get_section_keys(section)
	for k in keys:
		_change_config_and_zip(zip_writer, config_file, section, k)
	

func _change_config_and_zip(zip_writer, config_file, section, key):
	var relative_path_template = "streaming_data/{mod_name}/{section}/{file_name}"
	var zip_path_template = "{mod_name}/{section}/{file_name}"
	var value = config_file.get_value(section, key) as String;
	var file_name = value.get_file()
	var zip_path = zip_path_template.format({"mod_name": ui_select_mode_name, "section" : section, "file_name" : file_name});
	var relative_path = relative_path_template.format({"mod_name": ui_select_mode_name, "section" : section, "file_name" : file_name});
	zip_writer.start_file(zip_path);
	var to_zip_file = FileAccess.open(value, FileAccess.READ);
	zip_writer.write_file(to_zip_file.get_buffer(to_zip_file.get_length()))
	zip_writer.close_file()
	config_file.set_value(section, key,relative_path)
	to_zip_file.close()

func _check_mod_can_use(mod_name: String) -> bool:
	return true
	
func _evt_on_rename_click_callback(rename:String):
	var config_path = ui_select_mode_name + ".ini"
	var new_config_path = rename + ".ini"
	var dir = DirAccess.open(mod_path)
	dir.rename(config_path, new_config_path)
	if GameManager.mod_name == ui_select_mode_name:
		GameManager.mod_name = rename
		current_mod_label.text = rename
	ui_select_mode_name = rename
	_update_mod_list()
