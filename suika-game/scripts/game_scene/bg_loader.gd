extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
#	self.texture = load("./streaming_data/sprites/background.jpg")
	var path = ConfigManager.get_background_path();
	self.texture = ResourceManager.get_texture(path);
