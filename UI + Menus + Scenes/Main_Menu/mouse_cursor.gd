extends Node

# Preload cursor textures
var gameplay_default_cursor: Texture2D = preload("res://Finished_Assets/UI_Assets/UI_Cursor_Assets/Cursor_1.png")
var gameplay_click_cursor: Texture2D = preload("res://Finished_Assets/UI_Assets/UI_Cursor_Assets/Cursor_2.png")
var menu_default_cursor: Texture2D = preload("res://Finished_Assets/UI_Assets/UI_Cursor_Assets/Dollar_Sign_Mouse_1.png")
var menu_click_cursor: Texture2D = preload("res://Finished_Assets/UI_Assets/UI_Cursor_Assets/Dollar_Sign_Mouse_2.png")

var is_mouse_pressed = false
var gameplay_scenes = [
		"res://UI + Menus + Scenes/Gameplay/gameplay_scene.tscn",
		"res://UI + Menus + Scenes/Space_Scene/space_scene.tscn"
]

func _ready():
		print("Mouse Controller Ready")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().connect("node_added", Callable(self, "_on_Scene_Changed"))
		set_initial_cursor()
		# Set this to ensure we get input first
		process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event):
		if event is InputEventMouseButton:
				print("Mouse input detected in _input")
				if event.button_index == MOUSE_BUTTON_LEFT:
						is_mouse_pressed = event.pressed
						update_cursor()
						# Optionally, prevent the event from propagating
						# get_viewport().set_input_as_handled()

func _on_Scene_Changed(node):
		if node != self and (not node.is_in_group("persist")):
				set_initial_cursor()

func set_initial_cursor():
		update_cursor()

func update_cursor():
		# Wait until current_scene is available and has a valid scene_file_path
		while get_tree().current_scene == null or get_tree().current_scene.scene_file_path == null:
				await get_tree().process_frame
		
		var current_scene_path = get_tree().current_scene.scene_file_path
		
		var cursor
		var hotspot = Vector2.ZERO
		
		# Check if current scene is in the gameplay_scenes array
		var is_gameplay_scene = gameplay_scenes.has(current_scene_path)
		
		if is_gameplay_scene:
				cursor = gameplay_click_cursor if is_mouse_pressed else gameplay_default_cursor
				hotspot = Vector2(15, 15)
		else:
				cursor = menu_click_cursor if is_mouse_pressed else menu_default_cursor
				hotspot = Vector2(4, 0)
		
		Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, hotspot)

func _unhandled_input(event):
		if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT:
						is_mouse_pressed = event.pressed
						update_cursor()
