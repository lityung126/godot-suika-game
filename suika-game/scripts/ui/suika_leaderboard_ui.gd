extends Control

var leaderboard_item_prefab = preload("res://scenes/leaderboard_item.tscn")

@onready var leaderboard_item_parent = $ColorRect/VBoxContainer
@onready var today_button = $TodayButton
@onready var overall_button = $OverallButton
@onready var loading_control = $LoadingControl

var is_loading : bool = false
var leaderboard_items = [];

# Called when the node enters the scene tree for the first time.
func _ready():
	today_button.button_up.connect(_on_today_click)
	overall_button.button_up.connect(_on_overall_click)

func on_enable():
	if GameManager.can_use_leaderboard:
		self.visible = true
		today_button.set_pressed_no_signal(true)
		get_leaderboard("daily")
		_set_is_loading(true)
	else :
		self.visible = false
	

func _on_today_click():
	if not today_button.is_hovered():
		return
	get_leaderboard("daily")
	_set_is_loading(true)

func _on_overall_click():
	if not overall_button.is_hovered():
		return
		
	get_leaderboard("main")
	_set_is_loading(true)

func get_leaderboard(leaderboard_name : String):
	_clear_leaderboard()
	var sw_result: Dictionary = await SilentWolf.Scores.get_scores(10, leaderboard_name).sw_get_scores_complete
	var scores = sw_result.scores
	_arrange_ui(scores)
	_set_is_loading(false)

func _clear_leaderboard():
	for leaderboard_item in leaderboard_items:
		leaderboard_item.queue_free()
	leaderboard_items.clear();
	

func _arrange_ui(scores):
	if scores.is_empty():
		# no data
		return
	var rank = 1
	for score in scores:
		_add_leaderboard_item(rank, score)
		rank = rank+1

func _add_leaderboard_item(rank, score):
	var inst = leaderboard_item_prefab.instantiate()
	inst.get_node("RankTitleLabel").text = str(rank)
	inst.get_node("NameTitleLabel").text = score.player_name
	inst.get_node("ScoreTitleLabel").text = str(score.score)
	leaderboard_items.push_back(inst)
	leaderboard_item_parent.add_child(inst)

func _set_is_loading(enable : bool):
	is_loading = enable
	loading_control.visible = enable

