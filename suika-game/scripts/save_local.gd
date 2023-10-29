class_name SaveLocal

# 最高分
var top_score : int :get=_get_top_score, set=_set_top_score
func _set_top_score(value):
	PlayerPrefs.set_pref("top_score_score", value)
func _get_top_score():
	return PlayerPrefs.get_pref("top_score_score", -1)
# 主音量
var master_volume : float: get=_get_master_volume, set=_set_master_volume
func _set_master_volume(value):
	PlayerPrefs.set_pref("master_volume", value)
func _get_master_volume():
	return PlayerPrefs.get_pref("master_volume", 0.5)

# BGM音量
var bgm_volume : float: get=_get_bgm_volume, set=_set_bgm_volume
func _set_bgm_volume(value):
	PlayerPrefs.set_pref("bgm_volume", value)
func _get_bgm_volume():
	return PlayerPrefs.get_pref("bgm_volume", 0.5)

# 音效音量
var fx_volume : float: get=_get_fx_volume, set=_set_fx_volume
func _set_fx_volume(value):
	PlayerPrefs.set_pref("fx_volume", value)
func _get_fx_volume():
	return PlayerPrefs.get_pref("fx_volume", 0.5)

# 玩家名稱
var player_name: String: get=_get_player_name, set=_set_player_name
func _set_player_name(value):
	PlayerPrefs.set_pref("player_name", value)
func _get_player_name():
	return PlayerPrefs.get_pref("player_name", "")
