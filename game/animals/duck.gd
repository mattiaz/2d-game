extends CharacterBody2D

@export var speed : float = 50
@export var scatter_distance : float = 100
@onready var animation : AnimatedSprite2D = $Animation

var player : CharacterBody2D
var game : Node

var current_state : String = "idle"
var last_direction : String = "down"

func _physics_process(delta: float) -> void:
	if current_state == "dead":
		return

	handle_movement(delta)
	handle_animation()
	move_and_slide()

func get_direction(dir: Vector2) -> String:
	if dir.length() == 0:
		return last_direction

	if abs(dir.x) > abs(dir.y):
		return "right" if dir.x > 0 else "left"
	else:
		return "down" if dir.y > 0 else "up"

func handle_movement(delta: float) -> void:
	if not player:
		return

	if global_position.distance_to(player.global_position) < scatter_distance:
		var dir : Vector2 = (global_position - player.global_position).normalized()
		velocity = dir * speed
		last_direction = get_direction(velocity)
		current_state = "walk"
	else:
		velocity = Vector2.ZERO
		current_state = "idle"

func handle_animation() -> void:
	if velocity.length() > 0:
		current_state = "walk"
	else:
		current_state = "idle"

	play_animation(current_state)

func play_animation(name: String) -> void:
	# Attempt to scale animation speed when speed is changed
	animation.speed_scale = 1.0
	if name == "walk": animation.speed_scale = speed / 30

	animation.play(name + "_" + last_direction)

func die() -> void:
	velocity = Vector2.ZERO
	current_state = "dead"
	animation.play("dead")
	animation.connect("animation_finished", _on_death_animation_finished)

func _on_death_animation_finished() -> void:
	if game:
		game.inc_kill_count()
	queue_free()
