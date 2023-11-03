extends Control

@onready var close_button = $ColorRect/CloseButton
@onready var save_button = $ColorRect/SaveButton
# player section
@onready var player_section_v_box_container = $ColorRect/ScrollContainer/VBoxContainer/PlayerSectionVBoxContainer
# drop section
@onready var drop_section_v_box_container = $ColorRect/ScrollContainer/VBoxContainer/DropSectionVBoxContainer

@onready var confirmation_dialog:ConfirmationDialog = $ConfirmationDialog

var mod_path = "streaming_data/mods"
var _current_editing_mod_name = ""
var _current_config_file : ConfigFile = ConfigFile.new()

var is_modified = false

# Called when the node enters the scene tree for the first time.
func _ready():
	close_button.button_up.connect(_on_close_button_click)
	save_button.button_up.connect(_on_save_button_click)
	player_section_v_box_container.evt_on_config_modify.connect(on_evt_on_config_modify_callback)
	drop_section_v_box_container.evt_on_config_modify.connect(on_evt_on_config_modify_callback)
	confirmation_dialog.get_cancel_button().button_up.connect(_on_confirm_dialog_cancel_click)
	confirmation_dialog.get_ok_button().button_up.connect(_on_confirm_dialog_ok_click)
	
	if GameManager.os_web:
		mod_path = "res://" + mod_path

func on_evt_on_config_modify_callback():
	is_modified = true

func _on_close_button_click():
	if not close_button.is_hovered():
		return
	if is_modified == true:
		confirmation_dialog.visible = true
	else:
		UIManagerCanvas.hide_ui(UIManager.UI_NAMES.EditModUI)
	

func edit_mod(mod_name : String):
	is_modified = false
	_current_editing_mod_name = mod_name
	var path = mod_path + "/" + mod_name + ".ini"
	var file = FileAccess.open(path, FileAccess.READ);
	var content = file.get_as_text();
	_current_config_file.clear()
	_current_config_file.parse(content)
	
	_set_ui();

func _set_ui():
	# player section
	player_section_v_box_container.set_data(_current_config_file)
	# drops section
	drop_section_v_box_container.set_data(_current_config_file)
	

func _on_save_button_click():
	if not save_button.is_hovered():
		return
	_save()

func _on_confirm_dialog_ok_click():
	if not confirmation_dialog.get_ok_button().is_hovered():
		return
	print("save")
	_save()
	confirmation_dialog.visible = false
	UIManagerCanvas.hide_ui(UIManager.UI_NAMES.EditModUI)

func _on_confirm_dialog_cancel_click():
	if not confirmation_dialog.get_cancel_button().is_hovered():
		return
	print("no save")
	confirmation_dialog.visible = false
	UIManagerCanvas.hide_ui(UIManager.UI_NAMES.EditModUI)

func _save():
	is_modified = false
	var save_path = mod_path + "/" +_current_editing_mod_name+".ini";
	print("save file to : " + save_path)
	var err = _current_config_file.save(save_path);
	if err != OK:
		printerr ("save file fail " + error_string(err))
	if GameManager.mod_name == _current_editing_mod_name:
		# force mod update
		GameManager.mod_name = _current_editing_mod_name
