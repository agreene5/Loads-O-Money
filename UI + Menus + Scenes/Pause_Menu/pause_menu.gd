extends Control

@onready var pause_menu = $"."

func _unhandled_input(event):
	if Input.is_action_just_pressed("pause") and Global_Variables.is_paused:
		close_pause_menu()

func close_pause_menu():
	$Node2D/AnimationPlayer.play("Pause_End")
	get_parent().get_parent().unpausing()
	await $Node2D/AnimationPlayer.animation_finished
	get_tree().paused = false
	queue_free()
	Global_Variables.is_paused = false

func _on_resume_pressed() -> void:
	$Node2D/Resume.visible = false
	$Node2D/Quit.visible = false
	close_pause_menu()

func _on_quit_pressed() -> void:
	$Node2D/Resume.visible = false
	$Node2D/Quit.visible = false
	$Node2D/AnimationPlayer.play("Pause_End")
	ResourceLoader.load_threaded_request("res://UI + Menus + Scenes/Main_Menu/main_menu.tscn")
	await $Node2D/AnimationPlayer.animation_finished
	get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get("res://UI + Menus + Scenes/Main_Menu/main_menu.tscn"))
	Global_Variables.is_paused = false
