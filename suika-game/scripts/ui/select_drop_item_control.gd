extends Control

signal on_drop_item_created(path, drop_name, drop_score, drop_rate)
signal on_drop_item_edit_end(node ,path, drop_name, drop_score, drop_rate)

var is_for_edit : bool = false

@onready var select_drop_item_file_dialog = $SelectDropItemFileDialog

@onready var texture_rect = $ColorRect/TextureRect
@onready var select_drop_texture_button = $ColorRect/SelectDropTextureButton
@onready var close_button = $ColorRect/CloseButton

@onready var name_line_edit = $ColorRect/NameLineEdit
@onready var score_spin_box = $ColorRect/ScoreSpinBox
@onready var drop_rate_spin_box = $ColorRect/DropRateSpinBox
@onready var create_button = $ColorRect/CreateButton

var editting_node;
var drop_texture_path = "";

# Called when the node enters the scene tree for the first time.
func _ready():
	close_button.button_up.connect(_on_close_button_click)
	select_drop_texture_button.button_up.connect(_on_select_drop_texture_button_click)
	create_button.button_up.connect(_on_create_button_click)
	select_drop_item_file_dialog.file_selected.connect(_on_drop_item_texture_select)

func set_data(node, drop_name, drop_path, drop_score, drop_rate):
	editting_node = node
	name_line_edit.text = drop_name
	texture_rect.texture = ResourceManager.get_texture(drop_path)
	drop_texture_path = drop_path
	score_spin_box.value = drop_score
	drop_rate_spin_box.value = drop_rate
	
	is_for_edit = true
	name_line_edit.editable = false

func _on_select_drop_texture_button_click():
	if not select_drop_texture_button.is_hovered():
		return;
	select_drop_item_file_dialog.visible = true
	

func _on_close_button_click():
	if not close_button.is_hovered():
		return
	self.visible = false

func _on_drop_item_texture_select(file_path):
	texture_rect.texture = ResourceManager.get_texture(file_path)
	drop_texture_path = file_path
	
func _on_create_button_click():
	if not create_button.is_hovered():
		return
	# 防呆
	if drop_texture_path.is_empty():
		printerr("please select a texture")
		return
	if name_line_edit.text.is_empty():
		return
	select_drop_item_file_dialog.visible = false
	if is_for_edit == false:
		on_drop_item_created.emit(drop_texture_path,name_line_edit.text, score_spin_box.value, drop_rate_spin_box.value)
	else :
		on_drop_item_edit_end.emit(editting_node ,drop_texture_path,name_line_edit.text, score_spin_box.value, drop_rate_spin_box.value)
	
	
	
