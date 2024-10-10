extends Area2D

func _ready():
	await get_tree().create_timer(0.1).timeout # Short delay to prevent immediate dying (not sure why this occurs)
	area_entered.connect(_on_area_entered)


func _on_area_entered(area):
	Global_Variables.explosion_animation()
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout # Wait for explosion animation to finish
		
	print("You're Dead")
	get_tree().change_scene_to_file("res://Drowned_Scene.tscn")
