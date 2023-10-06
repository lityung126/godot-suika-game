extends Control


@onready var score_label_value = $ColorRect/SCORELabelValue
@onready var bestscore_label_value = $ColorRect/BESTSCORELabelValue
@onready var play_again_button = $ColorRect/PlayAgainButton

func _ready():
	play_again_button.button_up.connect(_on_play_again_click)
	

func _on_play_again_click():
	GameManager.restart_game();

