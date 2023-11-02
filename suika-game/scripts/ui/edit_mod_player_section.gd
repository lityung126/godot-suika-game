extends VBoxContainer

@onready var player_texture = $HBoxContainer/PlayerTexture
@onready var edit_button = $HBoxContainer/Button
@onready var path = $HBoxContainer/Path

@onready var select_player_file_dialog = $HBoxContainer/SelectPlayerFileDialog

@onready var x_spin_box = $AdjustPositionHBoxContainer/VBoxContainer/xHBoxContainer/xSpinBox
@onready var y_spin_box = $AdjustPositionHBoxContainer/VBoxContainer/yHBoxContainer/ySpinBox
@onready var player_texture_for_adjust_position = $AdjustPositionHBoxContainer/Control/PlayerTextureForAdjustPosition


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
	player_texture_for_adjust_position.position.x = offset_x
	player_texture_for_adjust_position.position.y = offset_y
	x_spin_box.set_value(offset_x)
	y_spin_box.set_value(offset_y)

func _on_edit_button_click():
	select_player_file_dialog.visible = true
	pass

func _on_player_image_file_selected(file_path : String):
	print("file select " + file_path)
	
	path.text = file_path
	player_texture.set_texture(ResourceManager.get_texture(file_path))
	player_texture_for_adjust_position.set_texture(ResourceManager.get_texture(file_path))
	config_file.set_value("player", "player_image_path", file_path)

func on_x_spin_box_value_change(value):
	player_texture_for_adjust_position.position.x = value
	config_file.set_value("player", "offset_x",value)
	
	pass

func on_y_spin_box_value_change(value):
	player_texture_for_adjust_position.position.y = value
	config_file.set_value("player", "offset_y",value)
	pass
