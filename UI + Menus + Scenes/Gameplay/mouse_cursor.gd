extends Node

var default_cursor: Resource = preload("res://Finished_Assets/UI_Assets/UI_Cursor_Assets/Cursor_1.png")
var click_cursor: Resource = preload("res://Finished_Assets/UI_Assets/UI_Cursor_Assets/Cursor_2.png")

func _ready():
		# Hide the default system cursor
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		# Set the default cursor with 15,15 hotspot
		Input.set_custom_mouse_cursor(default_cursor, Input.CURSOR_ARROW, Vector2(15, 15))

func _input(event):
		if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT:
						if event.pressed:
								# When mouse button is pressed, change to click cursor
								Input.set_custom_mouse_cursor(click_cursor, Input.CURSOR_ARROW, Vector2(15, 15))
						else:
								# When mouse button is released, change back to default cursor
								Input.set_custom_mouse_cursor(default_cursor, Input.CURSOR_ARROW, Vector2(15, 15))
