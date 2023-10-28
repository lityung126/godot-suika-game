extends Control

@onready var close_button = $ColorRect/CloseButton
@onready var save_button = $ColorRect/SaveButton
# player section
@onready var player_section_v_box_container = $ColorRect/ScrollContainer/VBoxContainer/PlayerSectionVBoxContainer
# drop section
@onready var drop_section_v_box_container = $ColorRect/ScrollContainer/VBoxContainer/DropSectionVBoxContainer

var mod_path = "streaming_data/mods"
var _current_editing_mod_name = ""
var _current_config_file : ConfigFile = ConfigFile.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	close_button.button_up.connect(_on_close_button_click)
	save_button.button_up.connect(_on_save_button_click)

	if GameManager.os_web:
		mod_path = "res://" + mod_path

func _on_close_button_click():
	UIManagerCanvas.hide_ui(UIManager.UI_NAMES.EditModUI)
	pass

func edit_mod(mod_name : String):
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
	var save_path = mod_path + "/" +_current_editing_mod_name+".ini";
	print("save file to : " + save_path)
	var err = _current_config_file.save(save_path);
	if err != OK:
		printerr ("save file fail " + error_string(err))
		

