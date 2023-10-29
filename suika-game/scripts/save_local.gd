class_name SaveLocal

# 最高分
var top_score : int :get=_get_top_score, set=_set_top_score

func _set_top_score(value : int):
	PlayerPrefs.set_pref("top_score_score", value)
	pass
	
func _get_top_score():
	return PlayerPrefs.get_pref("top_score_score", -1)

