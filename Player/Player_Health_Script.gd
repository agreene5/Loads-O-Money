extends Area2D #Unsure what node to put this onto


var hit_sfx = preload("res://Temp_Assets/Temp_SFX_Assets/Aah_Roland169.mp3")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)


func get_value():
	return Global_Variables.money
	
func receive_value(result):
	print("Money value:", Global_Variables.money)
func _on_area_entered(area):
	if area.has_method("receive_value") and area.is_in_group("projectile"):
		var projectile_health = area.get_value()
		$AudioStreamPlayer.stream = hit_sfx
		$AudioStreamPlayer.volume_db = -4
		$AudioStreamPlayer.play()
		if self.get_instance_id() < area.get_instance_id():
			Global_Variables.money -= projectile_health
			if(Global_Variables.money <= 0):
				print("Todd died")
				die()
	
	
	
func die(): #Bankruptcy
	Global_Variables.money = 0
	print("Todd is BROKE!")
	Global_Variables.explosion_animation()
	get_tree().paused = true
		
	var parent = get_parent()
	var player_sprite = parent.get_node_or_null("Player_Sprite")
	var shot_sprite = parent.get_node_or_null("Shot_In_Hand_Sprite")
	
	player_sprite.visible = false
	shot_sprite.visible = false
	
	await get_tree().create_timer(0.5).timeout # Wait for explosion animation to finish
	$AudioStreamPlayer.stream = load("res://Finished_Assets/Voice_Line_Assets/Death_Voice_Lines_1.wav")
	$AudioStreamPlayer.volume_db += 3  # Increase volume by 3 decibels
	$AudioStreamPlayer.play()
	
	await get_tree().create_timer(3.3).timeout
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Main_Menu/main_menu.tscn")
	player_sprite.visible = true
	shot_sprite.visible = true
	
func calculate_damage(shot_damage):
	$AudioStreamPlayer.stream(hit_sfx)
	
