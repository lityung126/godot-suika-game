extends RigidBody2D
class_name DropItemTemplate

var drop_name: String
var index : int 
var is_combining : bool
var is_first_collide :bool;

func _ready():
	self.body_entered.connect(_on_body_entered)
	
	var tween = get_tree().create_tween()
	self.scale = Vector2.ZERO
	tween.tween_property(self, "scale", Vector2(1, 1),0.1).set_trans(Tween.TRANS_LINEAR)
	# tween.tween_callback($Sprite.queue_free)
	
func _process(_delta):
	if is_first_collide : 
		if position.y < GameManager.dead_line_y:
			GameManager.game_over();
		

func add_poly_collider(spritePath : String):
	var bitmap = ResourceManager.get_bitmap(spritePath)
	var polygons = bitmap.opaque_to_polygons(Rect2(Vector2(0, 0), bitmap.get_size()))
	for polygon in polygons:
		var collider = CollisionPolygon2D.new()
		collider.polygon = polygon
		add_child(collider)
		collider.position = - bitmap.get_size() / 2
	center_of_mass_mode = RigidBody2D.CENTER_OF_MASS_MODE_CUSTOM
	center_of_mass = Vector2.ZERO

func add_texture(spritePath : String):
	var t = ResourceManager.get_texture(spritePath)
	$Sprite2D.texture = t
	

func _on_body_entered(body: Node):
	var dropItem = body as DropItemTemplate;
	if dropItem == null:
		return
	# 碰到drop item 後就可以開啟判定結束了
	is_first_collide = true;
	if index >= DropManager.drop_item_config_array.size() - 1:
		return
	if dropItem.index != self.index:
		return
	if dropItem.is_combining == true:
		return
	self.is_combining = true;
	dropItem.is_combining = true;
	
	var inst = DropManager.get_drop_item_by_index(index + 1)
	var scene = get_tree().current_scene
	# scene.add_child(inst)
	scene.call_deferred("add_child", inst)
	inst.position = (self.position + dropItem.position) / 2
	ScoreManager.add_score(drop_name);
	AudioManager.play_merge_sound();
	
	
	dropItem.hide();
	dropItem.queue_free()
	self.hide()
	self.queue_free()
