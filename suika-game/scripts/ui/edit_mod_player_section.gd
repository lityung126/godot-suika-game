extends VBoxContainer

@onready var player_texture = $HBoxContainer/PlayerTexture
@onready var edit_button = $HBoxContainer/Button
@onready var path = $HBoxContainer/Path

@onready var select_player_file_dialog = $HBoxContainer/SelectPlayerFileDialog

@onready var x_spin_box = $AdjustPositionHBoxContainer/VBoxContainer/xHBoxContainer/xSpinBox
@onready var y_spin_box = $AdjustPositionHBoxContainer/VBoxContainer/yHBoxContainer/ySpinBox
@onready var player_texture_for_adjust_position = $AdjustPositionHBoxContainer/Control/PlayerTextureForAdjustPosition

signal evt_on_config_modify()

var config_file : ConfigFile

func _ready():
	edit_button.button_up.connect(_on_edit_button_click)
	select_player_file_dialog.file_selected.connect(_on_player_image_file_selected)
	x_spin_box.value_changed.connect(on_x_spin_box_value_change);
	y_spin_box.value_changed.connect(on_y_spin_box_value_change);
	

func set_data(config_file):
	self.config_file = config_file
	var section_name = "player";
	var image_path = config_file.get_value(section_name, "player_image_path")
	path.text = image_path
	player_texture.set_texture(ResourceManager.get_texture(image_path))
	player_texture_for_adjust_position.set_texture(ResourceManager.get_texture(image_path))
	
	var offset_x = config_file.get_value(section_name, "offset_x")
	var offset_y = config_file.get_value(section_name, "offset_y")

	# for fix wrong position bug
	# set position twice and idk why
	_ini_pos(offset_x,offset_y)
	_ini_pos(offset_x,offset_y)

	x_spin_box.set_value_no_signal(offset_x)
	y_spin_box.set_value_no_signal(offset_y)

func _ini_pos(x: float,y:float):
	player_texture_for_adjust_position.position.x = x
	player_texture_for_adjust_position.position.y = y

func _on_edit_button_click():
	if not edit_button.is_hovered():
		return
	select_player_file_dialog.visible = true
	pass

func _on_player_image_file_selected(file_path : String):
	print("file select " + file_path)
	
	path.text = file_path
	player_texture.set_texture(ResourceManager.get_texture(file_path))
	player_texture_for_adjust_position.set_texture(ResourceManager.get_texture(file_path))
	config_file.set_value("player", "player_image_path", file_path)
	evt_on_config_modify.emit()

func on_x_spin_box_value_change(value):
	player_texture_for_adjust_position.position.x = value
	config_file.set_value("player", "offset_x",value)
	evt_on_config_modify.emit()

func on_y_spin_box_value_change(value):
	player_texture_for_adjust_position.position.y = value
	config_file.set_value("player", "offset_y",value)
	evt_on_config_modify.emit()
