extends Control

@onready var play_button = $ColorRect/PlayButton
@onready var setting_button = $ColorRect/SettingButton
@onready var texture_rect = $ColorRect/TextureRect
@onready var name_line_edit = $ColorRect/NameLineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	play_button.button_up.connect(_on_play_button_click)
	setting_button.button_up.connect(_on_setting_button_click)
	_load_bg();

func _on_play_button_click():
	GameManager.set_player_name(name_line_edit.text);
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")
	
func _on_setting_button_click():
	UIManagerCanvas.show_ui(UIManager.UI_NAMES.SettingUI);

func _load_bg():
	texture_rect.texture = ResourceManager.get_texture(ConfigManager.get_menu_background_path())
