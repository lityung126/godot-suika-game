extends PanelContainer

signal evt_on_delete_click(drop_name)
signal evt_on_edit_click(sender, drop_name, path, score, rate)

@onready var name_label = $HBoxContainer/VBoxContainer/NameLabel
@onready var player_texture = $HBoxContainer/PlayerTexture
@onready var drop_rate_label = $HBoxContainer/VBoxContainer/DropRateLabel
@onready var score_label = $HBoxContainer/VBoxContainer/ScoreLabel
@onready var delete_button = $HBoxContainer/ButtonVBoxContainer/DeleteButton
@onready var edit_button = $HBoxContainer/ButtonVBoxContainer/EditButton
var temp_data;
func _ready():
	delete_button.button_up.connect(_on_delete_button_click);
	edit_button.button_up.connect(_on_edit_button_click);
	
func set_data(data):
	temp_data = data
	name_label.text = data.name
	player_texture.set_texture(ResourceManager.get_texture(data.path))
	drop_rate_label.text = str(data.drop_rate)
	score_label.text = str(data.score)

func _on_delete_button_click():
	if not delete_button.is_hovered():
		return
	evt_on_delete_click.emit(name_label.text)
	
func _on_edit_button_click():
	if not edit_button.is_hovered():
		return
	evt_on_edit_click.emit(self, temp_data.name, temp_data.path, temp_data.score, temp_data.drop_rate)



