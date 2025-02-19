extends Node

@export var mob_scene: PackedScene
var score
var lives = 3
var time_left = 0 
var game_started = false  # Controla o estado do jogo

@onready var hud = $HUD
@onready var player = $Player
@onready var score_timer = $ScoreTimer
@onready var mob_timer = $MobTimer
@onready var start_timer = $StartTimer
@onready var start_position = $StartPosition
@onready var mob_path = $MobPath/LocalMobGeneration

func _ready() -> void:
	# Inicializa o jogo e conecta os sinais
	new_game()
	player.connect("hit", Callable(self, "_on_player_hit"))
	

func _process(_delta: float) -> void:
	pass

func game_over() -> void:
	score_timer.stop()
	mob_timer.stop()
	game_started = false

func new_game() -> void:
	score = 0
	lives = 3
	time_left = 0
	game_started = true
	hud.update_score(score)
	hud.update_lives(lives)
	hud.update_time(time_left)
	player.start(start_position.position)
	start_timer.start()
	mob_timer.start()

func _on_score_timer_timeout() -> void:
	score += 1
	hud.update_score(score)

func _on_start_timer_timeout() -> void:
	time_left += 1
	hud.update_time(time_left)
	score_timer.start()

func _on_player_hit() -> void:
	lives -= 1
	hud.update_lives(lives)
	print("Player hit. Lives: ", lives)
	
	if lives < 0:
		game_over()
		

func _on_mob_timer_timeout() -> void:
	print("Spawn mob")
	if game_started:
		var mob = mob_scene.instantiate()
		mob_path.progress_ratio = randf()
		var direction = mob_path.rotation + PI / 2
		mob.position = mob_path.position
		direction += randf_range(-PI / 4, PI / 4)
		mob.rotation = direction
		var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
		mob.linear_velocity = velocity.rotated(direction)
		add_child(mob)
