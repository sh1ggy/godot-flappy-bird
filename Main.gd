extends Node
export (PackedScene) var Pipe;
const DISPLAY_HEIGHT = 256;
const GROUND_HEIGHT = 56;
const PIPE_DIST = 21;
const PIPE_LIST_COUNT = 10;
var pipe_list = [];
var timer = 0;
const MAX_TIMER = 1;
var score;
export var speed = 30; 
signal game_over;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# cooldown type concept
	if (timer >= MAX_TIMER): 
		timer = 0;
	timer += delta;
	
func _on_Ground_body_entered(body):
	# handle ground collision
	game_over();

func _on_Pipe_body_entered():
	game_over();
	
func _on_Score():
	score += 1;
	$HUD.update_score(score);
	
func game_over():
	$PipeTimer.stop();
	$HUD.show_game_over(score);
	$Player._on_game_over();
	emit_signal("game_over");

func _on_PipeTimer_timeout():
	var pipe = Pipe.instance();
	add_child(pipe);
	# checking to see if it's required to remove a pipe that is off-screen
	if (pipe_list.size() >= PIPE_LIST_COUNT):
		var to_delete_pipe = pipe_list.pop_front();
		to_delete_pipe.queue_free();
	pipe_list.append(pipe);
	# hardcoded values  
	var pipe_range = rand_range(PIPE_DIST, DISPLAY_HEIGHT - GROUND_HEIGHT - PIPE_DIST);
	# setting position of pipe to be spawned
	pipe.position = Vector2($PipePosition.position.x, pipe_range);
	# <source_node>.connect(<signal_name>, <target_node>, <target_function_name>)
	pipe.connect("collision", self, "_on_Pipe_body_entered");
	pipe.connect("score", self, "_on_Score");
	connect("game_over", pipe, "game_over");
	
func _on_HUD_start_game():
	score = 0;
	$PipeTimer.start();
	_on_PipeTimer_timeout();
	$Player.start($PlayerStartPosition.position); 
	$PipeTimer.start();
	$HUD.update_score(score);
	
