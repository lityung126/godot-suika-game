extends Control

@onready var score_label_value = $ColorRect/SCORELabelValue
@onready var bestscore_label_value = $ColorRect/BESTSCORELabelValue
@onready var play_again_button = $ColorRect/PlayAgainButton
@onready var wait_label = $ColorRect/WaitLabel


func _ready():
	play_again_button.button_up.connect(_on_play_again_click)
	

func _on_play_again_click():
	if not play_again_button.is_hovered():
		return
	GameManager.restart_game();

func on_enable():
	# 此處會在更新最高分前被呼叫 所以可以讀取top score 來當作上次最高分
	# 並可以直接比較得分與高分 來判斷 是否分數更新
	# 但要注意沒紀錄時 分數會是 -1 避免顯示怪怪的要改成0
	var isNewRecord = false
	var topScore = 0;
	if ScoreManager.current_score > ScoreManager.get_top_score():
		isNewRecord = true
	topScore = ScoreManager.get_top_score()
	if topScore == -1:
		topScore = 0
	
	score_label_value.text = str(ScoreManager.current_score)
	if isNewRecord:
		bestscore_label_value.text =  str(topScore) + "->" + str(ScoreManager.current_score)
	else : 
		bestscore_label_value.text =  str(topScore)
	if GameManager.can_use_leaderboard:
		play_again_button.visible = false
		wait_label.visible = true
		var sw_result: Dictionary = await SilentWolf.Scores.save_score(GameManager.player_name, ScoreManager.current_score).sw_save_score_complete
		var daily_sw_result: Dictionary = await SilentWolf.Scores.save_score(GameManager.player_name, ScoreManager.current_score, "daily").sw_save_score_complete
		play_again_button.visible = true
		wait_label.visible = false
		print("Score persisted successfully: " + str(sw_result.score_id))
	else :
		play_again_button.visible = true
		wait_label.visible = false
