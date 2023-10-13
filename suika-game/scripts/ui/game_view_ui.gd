extends Control
class_name GameViewUI

@onready var scoreLabel = $ColorRect/ScoreLabel
@onready var top_score_label = $ColorRect/TopScoreLabel
@onready var nextTextureRect = $ColorRect2/NextTextureRect
@onready var setting_button = $SettingButton
@onready var leaderboard = $Leaderboard

var updateTextureRectCallable : Callable
var _update_score_text_callable : Callable

# Called when the node enters the scene tree for the first time.
func _ready():
	_updateTextureRect()
	_update_score_text()
	updateTextureRectCallable = _updateTextureRect.bind()
	_update_score_text_callable = _update_score_text.bind()
	setting_button.button_up.connect(_on_setting_click)
	DropManager.event_on_next_drop_item_update.connect(updateTextureRectCallable);
	ScoreManager.event_on_score_update.connect(_update_score_text_callable);

func _exit_tree():
	DropManager.event_on_next_drop_item_update.disconnect(updateTextureRectCallable);
	ScoreManager.event_on_score_update.disconnect(_update_score_text_callable);

func _update_score_text():
	scoreLabel.text = str(ScoreManager.current_score)

func _updateTextureRect():
	var next_name = DropManager.next_drop_item_name
	for drop_item_config in DropManager.drop_item_config_array:
		if drop_item_config.name == next_name:
			nextTextureRect.texture = ResourceManager.get_texture(drop_item_config.image_path)

func _on_setting_click():
	UIManagerCanvas.show_ui(UIManager.UI_NAMES.SettingUI);

func on_enable():
	top_score_label.text = ScoreManager.get_top_score_string()
	leaderboard.on_enable();
