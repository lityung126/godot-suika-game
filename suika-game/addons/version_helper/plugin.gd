@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_autoload_singleton("VersionHelper", "res://addons/version_helper/version_helper.tscn")
