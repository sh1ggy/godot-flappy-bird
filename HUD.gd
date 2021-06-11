extends CanvasLayer
signal start_game;
var game_over = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	$ScoreLabelSG.hide();
	$GameOverHUD.hide();
	if (get_node("/root/Global").is_shown_start):
		emit_signal("start_game");
		$StartButton.hide();
		$TitleText.hide();
		$ScoreLabelSG.show();
		return;
	$TitleText.show();
	
func show_game_over(score):
	game_over = true;
	$ScoreLabelSG.hide();
	$GameOverHUD/ScoreLabelGO.text = str(score);
	if (score > get_node("/root/Global").highscore):
		get_node("/root/Global").highscore = score;
	$GameOverHUD/HighScoreGO.text = "Highscore:" + str(get_node("/root/Global").highscore);
	$GameOverHUD/ScoreLabelGO.show();
	$GameOverHUD.show();
	$StartButton.show();
	
func update_score(score):
	$ScoreLabelSG.text = str(score);

func _on_StartButton_pressed():
	get_node("/root/Global").is_shown_start = true;
	if (game_over):
		get_tree().reload_current_scene();
		return;
	$StartButton.hide();
	$GameOverHUD.hide();
	$TitleText.hide();
	$ScoreLabelSG.show();
	emit_signal("start_game");
