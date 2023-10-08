extends Node2D

func _ready():
	UIManagerCanvas.hide_all_ui();
	UIManagerCanvas.show_ui(UIManager.UI_NAMES.GameViewUI);
