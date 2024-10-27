extends Control

@onready var pause_menu = $"."
@onready var todd = $Sprite2D
var paused = false

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		pauseMenu()

func pauseMenu():
	if paused:
		
		pause_menu.hide()
		
		Engine.time_scale =1
	else:
		
		pause_menu.show()
		
		
		Engine.time_scale =0
	paused = !paused
	



func _on_resume_pressed() -> void:
	pauseMenu()


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Main_Menu/main_menu.tscn")
