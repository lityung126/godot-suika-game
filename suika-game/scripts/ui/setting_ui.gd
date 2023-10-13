extends Control
class_name SettingUI

@onready var lang_option_button = $ColorRect/VBoxContainer/Lang_VBoxContainer/LangOptionButton

@onready var main_sound_h_slider = $ColorRect/VBoxContainer/SOUND_VBoxContainer/MAIN_SOUND/HSlider
@onready var main_sound_value = $ColorRect/VBoxContainer/SOUND_VBoxContainer/MAIN_SOUND/main_sound_value
@onready var bgm_sound_h_slider = $ColorRect/VBoxContainer/SOUND_VBoxContainer/BGM_SOUND/HSlider
@onready var bgm_sound_value = $ColorRect/VBoxContainer/SOUND_VBoxContainer/BGM_SOUND/bgm_sound_value
@onready var fx_sound_h_slider = $ColorRect/VBoxContainer/SOUND_VBoxContainer/FX_SOUND/HSlider
@onready var fx_sound_value = $ColorRect/VBoxContainer/SOUND_VBoxContainer/FX_SOUND/fx_sound_value
@onready var close_button = $ColorRect/CloseButton
@onready var on_check_box = $ColorRect/VBoxContainer/Game_VBox/Label/OnCheckBox
@onready var off_check_box = $ColorRect/VBoxContainer/Game_VBox/Label/OffCheckBox
@onready var version_label = $ColorRect/VersionLabel



func _ready():
	lang_option_button.item_selected.connect(_on_lang_change);
	main_sound_h_slider.value_changed.connect(_on_main_sound_h_slider_change)
	bgm_sound_h_slider.value_changed.connect(_on_bgm_sound_h_slider_change)
	fx_sound_h_slider.value_changed.connect(_on_fx_sound_h_slider_change)
	close_button.button_up.connect(_on_close_click)
	on_check_box.toggled.connect(_on_check_box_change)
	
	main_sound_h_slider.set_value_no_signal(AudioManager.master_volume)
	main_sound_value.text = str(AudioManager.master_volume)
	bgm_sound_h_slider.set_value_no_signal(AudioManager.bgm_volume)
	bgm_sound_value.text = str(AudioManager.bgm_volume)
	fx_sound_h_slider.set_value_no_signal(AudioManager.fx_volume)
	fx_sound_value.text = str(AudioManager.fx_volume)
	
	on_check_box.set_pressed_no_signal(GameManager.assistive_line_enable)
	off_check_box.set_pressed_no_signal(not GameManager.assistive_line_enable)
	version_label.text = VersionHelper.get_version();

func _on_check_box_change(enabled : bool):
	GameManager.set_assistive_line_enable(enabled)
	pass

func _process(_delta):
	if Input.is_action_just_released("ui_cancel"):
		_on_close_click()

func _exit_tree():
	lang_option_button.item_selected.disconnect(_on_lang_change);
	main_sound_h_slider.value_changed.disconnect(_on_main_sound_h_slider_change)
	bgm_sound_h_slider.value_changed.disconnect(_on_bgm_sound_h_slider_change)
	fx_sound_h_slider.value_changed.disconnect(_on_fx_sound_h_slider_change)
	close_button.button_up.disconnect(_on_close_click)

func _on_main_sound_h_slider_change(value : float):
	main_sound_value.text = str(value)
	AudioManager.set_master_volume(value)
	pass

func _on_bgm_sound_h_slider_change(value : float):
	bgm_sound_value.text = str(value)
	AudioManager.set_bgm_volume(value)
	pass
	
func _on_fx_sound_h_slider_change(value : float):
	fx_sound_value.text = str(value)
	AudioManager.set_fx_volume(value)
	pass

func _on_lang_change(index: int):
	match index:
		0:
			TranslationServer.set_locale("zh_tw")
		1:
			TranslationServer.set_locale("en")
		2:
			TranslationServer.set_locale("ja")

func _on_close_click():
	UIManagerCanvas.hide_ui(UIManager.UI_NAMES.SettingUI);

