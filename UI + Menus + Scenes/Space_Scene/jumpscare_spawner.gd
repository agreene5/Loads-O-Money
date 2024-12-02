extends CanvasLayer

@onready var pause_menu_scene = preload("res://UI + Menus + Scenes/Space_Scene/todd_jumpscare.tscn")

func spawn_jumpscare():
	get_tree().paused = true
	var pause_menu_instance = pause_menu_scene.instantiate()
	add_child(pause_menu_instance)
