extends Node2D

signal collision;
signal score;
var game_over = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over = false; # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (game_over):
		return;
	position += Vector2.LEFT * get_node("/root/Main").speed * delta;

func _on_TopPipe_body_entered(body):
	emit_signal("collision");

func _on_BottomPipe_body_entered(body):
	emit_signal("collision");
	
func _on_ScoreArea_body_entered(body):
	emit_signal("score");

func game_over():
	game_over = true;
