extends Control

@onready var pause_menu = $"."
@onready var todd = $Sprite2D
var paused = false

func _process(delta):
	if Input.is_action_just_pressed("esc"):
		pauseMenu()

func pauseMenu():
	if paused:
		var tween = create_tween()
		pause_menu.hide()
		tween.tween_property(todd, "position", Vector2(20,0), 1)
		Engine.time_scale =1
	else:
		var tween = create_tween()
		pause_menu.show()
		tween.tween_property(todd, "position", Vector2(-200,0), 5)
		
		Engine.time_scale =0
	paused = !paused
	



func _on_resume_pressed() -> void:
	pauseMenu()


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Main_Menu/main_menu.tscn")
