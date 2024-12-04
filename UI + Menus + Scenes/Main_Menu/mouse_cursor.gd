extends Node

# Preload cursor textures
var gameplay_default_cursor: Texture2D = preload("res://Finished_Assets/UI_Assets/UI_Cursor_Assets/Cursor_1.png")
var gameplay_click_cursor: Texture2D = preload("res://Finished_Assets/UI_Assets/UI_Cursor_Assets/Cursor_2.png")
var menu_default_cursor: Texture2D = preload("res://Finished_Assets/UI_Assets/UI_Cursor_Assets/Dollar_Sign_Mouse_1.png")
var menu_click_cursor: Texture2D = preload("res://Finished_Assets/UI_Assets/UI_Cursor_Assets/Dollar_Sign_Mouse_2.png")

var is_mouse_pressed = false

func _ready():
	# Ensure the mouse is visible but custom
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# Connect to the scene changed signal
	get_tree().connect("node_added", Callable(self, "_on_Scene_Changed"))
	set_initial_cursor()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_mouse_pressed = event.pressed
			print("Mouse pressed: ", is_mouse_pressed)
			update_cursor()

func _on_Scene_Changed(node):
	# Only react if the node added is not this script or not in a persistent group
	if node != self and (not node.is_in_group("persist")):
		set_initial_cursor()

func set_initial_cursor():
	update_cursor()

func update_cursor():
	var scene_name = get_tree().current_scene.name if get_tree().current_scene else ""
	print("Updating cursor for scene: ", scene_name, " Mouse state: ", is_mouse_pressed)
	var cursor
	var hotspot = Vector2.ZERO
	
	if scene_name == "Gameplay_Scene":
		cursor = gameplay_click_cursor if is_mouse_pressed else gameplay_default_cursor
		hotspot = Vector2(15, 15)
	else:
		cursor = menu_click_cursor if is_mouse_pressed else menu_default_cursor
		hotspot = Vector2(4, 0)
	
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, hotspot)
	print("Cursor set to: ", cursor.resource_path, " for scene: ", scene_name)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_mouse_pressed = event.pressed
			print("Mouse button event captured: ", is_mouse_pressed)
			update_cursor()
