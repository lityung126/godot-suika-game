extends CanvasLayer
class_name UIManager

enum UI_NAMES {GameViewUI, SettingUI, GameOverUI, MenuUI }

var _ui_dict = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	_ui_dict[UI_NAMES.GameViewUI] = $UIRoot/GameViewUI
	_ui_dict[UI_NAMES.SettingUI] = $UIRoot/SettingUI
	_ui_dict[UI_NAMES.GameOverUI] = $UIRoot/GameOverUI
	_ui_dict[UI_NAMES.MenuUI] = $UIRoot/MenuUI

func show_ui(ui_name : UI_NAMES):
	_ui_dict[ui_name].visible = true
	if _ui_dict[ui_name].has_method("on_enable"):
		_ui_dict[ui_name].on_enable();
	_update_ui_lock()

func hide_ui(ui_name : UI_NAMES):
	_ui_dict[ui_name].visible = false
	_update_ui_lock()

func hide_all_ui():
	for ui in _ui_dict.values():
		ui.visible = false
	_update_ui_lock()

func _update_ui_lock():
	# 任意ui打開
	if _ui_dict[UI_NAMES.SettingUI].visible or _ui_dict[UI_NAMES.GameOverUI].visible:
		get_tree().current_scene.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		get_tree().current_scene.process_mode = Node.PROCESS_MODE_INHERIT

func is_ui_active(ui_name : UI_NAMES) -> bool:
	return _ui_dict[ui_name].visible
