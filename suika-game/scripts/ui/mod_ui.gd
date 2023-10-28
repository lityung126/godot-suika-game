extends Control

@onready var v_box_container = $ColorRect/ScrollContainer/VBoxContainer
@onready var mod_item_prefab = preload("res://scenes/mod_item.tscn");

@onready var delete_button = $ColorRect/DeleteButton
@onready var create_button = $ColorRect/CreateButton
@onready var edit_button = $ColorRect/EditButton
@onready var active_button = $ColorRect/ActiveButton

@onready var close_button = $ColorRect/CloseButton

@onready var current_mod_label = $ColorRect/CurrentModLabel

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
	
	close_button.button_up.connect(_on_close_button_click)
	
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

func _on_mod_item_click(sender):
	ui_select_mode_name = sender.name
	
	delete_button.visible = ui_select_mode_name != CANT_DELETE_MOD
	edit_button.visible = ui_select_mode_name != CANT_DELETE_MOD
	active_button.visible = _check_mod_can_use(ui_select_mode_name)

func _on_delete_click():
	var dir = DirAccess.open(mod_path)
	dir.remove(ui_select_mode_name + ".ini")
	if GameManager.mod_name == ui_select_mode_name:
		GameManager.mod_name = DEFAULT_MOD_NAME
		current_mod_label.text = GameManager.mod_name
	ui_select_mode_name = DEFAULT_MOD_NAME
	_update_mod_list()

func _on_create_click():
	var dir = DirAccess.open(mod_path)
	var reference_file_name = DEFAULT_MOD_NAME
	var index : int = 1;
	while(dir.file_exists(reference_file_name + str(index) + ".ini")):
		index = index + 1
	var new_file_name = reference_file_name + str(index) + ".ini";
	print("try copy " + reference_file_name + ".ini" + " to " + new_file_name)
	var err = dir.copy(mod_path+ "/" +reference_file_name + ".ini", mod_path+ "/" +new_file_name)
	if err != OK:
		printerr("copy fail : " + error_string(err))
		
	_update_mod_list()
	pass

func _on_active_click():
	GameManager.mod_name = ui_select_mode_name
	current_mod_label.text = GameManager.mod_name
	
	on_mod_changed.emit()
	pass

func _on_edit_click():
	var editModUI = UIManagerCanvas.show_ui(UIManager.UI_NAMES.EditModUI)
	editModUI.edit_mod(ui_select_mode_name)
	

func _on_close_button_click():
	UIManagerCanvas.hide_ui(UIManager.UI_NAMES.ModUI);

func _check_mod_can_use(mod_name: String) -> bool:
	return true
	
