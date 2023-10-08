class_name SaveLocal

var top_score : LeaderboardData

func load():
	top_score = LeaderboardData.new(-1);
	top_score.score = PlayerPrefs.get_pref("top_score_score", -1)
	top_score.create_time_unix_float = PlayerPrefs.get_pref("create_time_unix_float", 0)


func save():
	PlayerPrefs.set_pref("top_score_score", top_score.score)
	PlayerPrefs.set_pref("create_time_unix_float", top_score.create_time_unix_float)
