extends CharacterBody2D

@export var speed : float = 100
@export var attack_range : float = 50
@onready var animation : AnimatedSprite2D = $Animation

# Keep track of first direction for movement animation
var pressed_directions : Array = []
# Keep track of player state
var current_state : String = "idle"
# Keep track of player direction
var last_direction : String = "down"

func _physics_process(delta: float) -> void:
	handle_input()
	handle_movement()
	handle_animation()
	move_and_slide()

func handle_input() -> void:
	for dir in ["up", "down", "left", "right"]:
		if Input.is_action_just_pressed(dir):
			pressed_directions.push_back(dir)
		if Input.is_action_just_released(dir):
			pressed_directions.erase(dir)

	if Input.is_action_just_pressed("slash") and current_state != "attack":
		perform_attack()

func handle_movement() -> void:
	var dir : Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = dir * speed

	if pressed_directions.size() > 0:
		last_direction = pressed_directions[0]

func handle_animation() -> void:
	if current_state == "attack":
		play_animation("attack")
		return

	if velocity.length() > 0:
		current_state = "walk"
	else:
		current_state = "idle"

	play_animation(current_state)

func play_animation(name: String) -> void:
	# Attempt to scale animation speed when speed is changed
	animation.speed_scale = 1.0
	if name == "walk": animation.speed_scale = speed / 100

	animation.play(name + "_" + last_direction)

func _animation_finished() -> void:
	if current_state == "attack":
		current_state = "idle"

func perform_attack() -> void:
	current_state = "attack"
	for duck in get_tree().get_nodes_in_group("ducks"):
		if in_range(duck):
			duck.die()

func in_range(obj: Node) -> bool:
	# Calculate the direction vector from the player to the obj
	var dir = (obj.global_position - global_position).normalized()
	# Calculate the distance to the obj
	var dist = global_position.distance_to(obj.global_position)
	# Check if the duck is within the attack range and in front of the player
	return dist <= attack_range and dir.dot(get_direction_vector()) > 0.5

func get_direction_vector() -> Vector2:
	match last_direction:
		"up": return Vector2(0, -1)
		"down": return Vector2(0, 1)
		"left": return Vector2(-1, 0)
		"right": return Vector2(1, 0)
	return Vector2.ZERO
