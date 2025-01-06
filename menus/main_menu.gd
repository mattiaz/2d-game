extends Control

# Keep track of all menu items
@onready var menu : Control = $Sticky/Menu
var menu_items : Array = []
var menu_index : int = 0

# Label styles for active / normal item
var style_normal : LabelSettings = preload("res://menus/menu_item_style.tres")
var style_active : LabelSettings = preload("res://menus/menu_item_selected_style.tres")

# Register a signal for when items are selected
signal item_selected(item_name)

func _ready() -> void:
	menu_items = menu.get_children()
	connect("item_selected", _on_item_selected)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		navigate_menu(-1)
	elif event.is_action_pressed("down"):
		navigate_menu(1)
	elif event.is_action_pressed("choose"):
		emit_signal("item_selected", menu_items[menu_index].name)
	elif event is InputEventMouseButton and event.pressed:
		_handle_mouse_click(event.position)

func _handle_mouse_click(pos: Vector2) -> void:
	for item : Label in menu_items:
		# Mouse click "inside" label
		if item.get_global_rect().has_point(pos):
			emit_signal("item_selected", item.name)

func _on_item_selected(action: String) -> void:
	match action:
		"Play": play()
		"Settings": settings()
		"Exit": exit()

func navigate_menu(dir: int) -> void:
	menu_items[menu_index].label_settings = style_normal
	menu_index = (menu_index + dir) % menu_items.size()
	if menu_index < 0: menu_index = menu_items.size() - 1
	menu_items[menu_index].label_settings = style_active

func play() -> void:
	get_tree().change_scene_to_file("res://game/game.tscn")

func settings() -> void:
	print("Open settings...")

func exit() -> void:
	get_tree().quit()
