extends Control

@onready var pause_menu = $"."
@onready var color_rect = $fade
@onready var animation_player = $AnimationPlayer
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
	color_rect.visible = true
	animation_player.play("fade out")
	await get_tree().create_timer(1.5).timeout
	Global_Variables.is_paused = false
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Main_Menu/main_menu.tscn")
