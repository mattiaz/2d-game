extends Node2D

@export var duck_scene : PackedScene
@export var tree_scene : PackedScene
@export var number_of_ducks : int = 10
@export var number_of_trees : int = 20
@onready var label : Label = $Static/Top/Count

var kill_count : int = 0

func _ready() -> void:
	spawn_objects(duck_scene, number_of_ducks, "ducks")
	spawn_objects(tree_scene, number_of_trees, "trees")
	update_label()

func rand_range(min: float, max: float) -> float:
	return min + randf() * (max - min)

func spawn_objects(scene: PackedScene, count: int, group: String) -> void:
	var spawn_area : Rect2 = get_viewport().get_visible_rect()

	for i in range(count):
		var instance = scene.instantiate()
		add_child(instance)

		instance.global_position = Vector2(
			rand_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
			rand_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		)

		instance.add_to_group(group)

		if group == "ducks":
			instance.set("player", get_node("%Player"))
			instance.set("game", self)

func update_label() -> void:
	label.text = "Killed: " + str(kill_count)

func inc_kill_count() -> void:
	kill_count += 1
	update_label()
