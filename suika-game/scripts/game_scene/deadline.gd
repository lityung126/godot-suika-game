extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.set_dead_line_y(position.y)
	pass # Replace with function body.
