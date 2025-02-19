extends RigidBody2D

@export var speed: float = 50.0

var screen_size: Vector2
var direction: int = 1

func _ready() -> void:
	screen_size = get_viewport_rect().size
	var enemy_types = $AnimatedSprite2D.sprite_frames.get_animation_names()
	$AnimatedSprite2D.play(enemy_types[randi() % enemy_types.size()])

func _process(delta: float) -> void:
	move_and_patrol(delta)

func move_and_patrol(delta: float) -> void:
	var velocity = Vector2(speed * direction, 0) * delta
	global_position += velocity

	if direction == 1 and global_position.x >= screen_size.x:
		direction = -1
	elif direction == -1 and global_position.x <= 0:
		direction = 1

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
