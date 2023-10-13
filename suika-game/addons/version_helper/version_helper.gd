extends Node

func get_version() -> String:
	var file = FileAccess.open("res://addons/version_helper/version.ini", FileAccess.READ);
	return file.get_as_text()
	
