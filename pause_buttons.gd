extends Control

@onready var main = "res://gameplay_scene.tscn"


func _on_resume_pressed() -> void:
	main.pauseMenu()


func _on_pause_pressed() -> void:
	get_tree().quit()
