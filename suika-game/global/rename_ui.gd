extends Control

signal evt_on_rename_click(name:String)

@onready var line_edit = $ColorRect/LineEdit
@onready var cancel_button = $ColorRect/CancelButton
@onready var confirm_button = $ColorRect/ConfirmButton



# Called when the node enters the scene tree for the first time.
func _ready():
	confirm_button.button_up.connect(_on_confirm_button_click);
	cancel_button.button_up.connect(_on_cancel_button_click);



func _on_confirm_button_click():
	if not confirm_button.is_hovered():
		return;
	if line_edit.text.is_empty():
		printerr("text null")
	else :
		evt_on_rename_click.emit(line_edit.text)
		self.visible = false
		

func _on_cancel_button_click():
	if not cancel_button.is_hovered():
		return;
	self.visible = false
	pass
