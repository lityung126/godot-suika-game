extends Control

@onready var play_button = $ColorRect/PlayButton
@onready var setting_button = $ColorRect/SettingButton

# Called when the node enters the scene tree for the first time.
func _ready():
	play_button.button_up.connect(_on_play_button_click)
	setting_button.button_up.connect(_on_setting_button_click)

func _on_play_button_click():
	get_tree().change_scene_to_file("res://scenes/game_scene.tscn")
	
func _on_setting_button_click():
	UIManagerCanvas.show_ui(UIManager.UI_NAMES.SettingUI);
