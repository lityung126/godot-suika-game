class_name LeaderboardData

var create_time_unix_float : float;
var score : int;

func _init(_score):
	create_time_unix_float = Time.get_unix_time_from_system()
	score = _score;	
	pass

func to_date_time():
	return Time.get_datetime_dict_from_unix_time(create_time_unix_float)
