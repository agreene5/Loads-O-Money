extends Control

@onready var pause_menu = $"."

func _unhandled_input(event):
	if Input.is_action_just_pressed("pause") and Global_Variables.is_paused:
		close_pause_menu()

func close_pause_menu():
	get_tree().paused = false
	queue_free()
	Global_Variables.is_paused = false

func _on_resume_pressed() -> void:
	close_pause_menu()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Main_Menu/main_menu.tscn")
	Global_Variables.is_paused = false
