extends KinematicBody2D
export var GRAVITY = 9.8;
export var velocity = Vector2();
export var jump_velocity = 1; 
var screen_size;
var game_over = false; # refer to main node, in future

# Called when the node enters the scene tree for the first time.
func _ready():
	game_over = true;
	screen_size = get_viewport_rect().size;
	hide();

func _on_game_over():
	$AnimationPlayer.play("idle");
	game_over = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (game_over): 
		return;
	velocity.y += delta * GRAVITY;
	if (position.y <= 0):
		game_over = true;
		$"/root/Main".game_over();
	
	var motion = velocity * delta; # distance that something should move in two frames (vel*time = dist)
	move_and_collide(motion);

func _process(delta):
	if (Input.is_action_just_pressed("jump") && !game_over):
		velocity = Vector2.UP * jump_velocity;
	# removing negative with one value
	var normalized_jump = velocity.y + jump_velocity;
	# ensuring that normalized_jump is value you want between -ve to +ve (A,B)
	var t = (clamp(normalized_jump, 0, 2 * jump_velocity)) / (2 * jump_velocity);
	$FlappyBird.rotation = deg2rad(-60) * (1 - t) + deg2rad(60) * t;

func start(pos):
	game_over = false;
	position = pos;
	show();
	$CollisionShape2D.disabled = false;
