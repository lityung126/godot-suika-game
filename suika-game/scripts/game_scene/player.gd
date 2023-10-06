extends Node2D
class_name player

# 丟下的間隔
@export var drop_interval : float = 0.5;
@export var speed : float = 100;
@export var move_area : Sprite2D;
@export var hand_node : Node2D;

var _drop_interval_timer : float = 0;
var currentDropItem : Node

var left_bound;
var right_bound;

# Called when the node enters the scene tree for the first time.
func _ready():
	var rect = move_area.get_rect()
	left_bound = move_area.position.x + rect.position.x * move_area.scale.x;
	right_bound = move_area.position.x + rect.end.x * move_area.scale.x;
	
	self.position.x = (left_bound + right_bound) / 2
	self.position.y = move_area.position.y;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var input_vector_x = Input.get_action_strength("player_right") - Input.get_action_strength("player_left");
	
	if input_vector_x != 0 :
		move_local_x(input_vector_x * speed * delta);
	
	if position.x < left_bound:
		position.x = left_bound
	elif position.x > right_bound:
		position.x = right_bound
	
	if currentDropItem == null and _drop_interval_timer < drop_interval:
		_drop_interval_timer += delta
	elif currentDropItem == null and _drop_interval_timer >= drop_interval: 
		_getDropItemInHand()
		_drop_interval_timer = 0
	elif Input.is_action_pressed("player_drop"):
		_dropItem()

func _getDropItemInHand():
	var inst = DropManager.get_random_drop_item()
	if inst == null:
		printerr("DropManager.get_random_drop_item null ??")
	add_child(inst)
	currentDropItem = inst
	var instRB = currentDropItem as RigidBody2D
	instRB.freeze = true
	instRB.set_collision_layer_value(1 , false)
	instRB.set_collision_mask_value(1 , false)
	
func _dropItem():
	var tempNode = currentDropItem
	tempNode.position.y += 5
	# remove_child(tempNode)
	tempNode.reparent(get_tree().current_scene, true)
	
	var instRB = tempNode as RigidBody2D
	instRB.freeze = false
	instRB.set_collision_layer_value(1 , true)
	instRB.set_collision_mask_value(1 , true)
	currentDropItem = null
