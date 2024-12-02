extends Area2D

@onready var audio_player = AudioStreamPlayer.new()

func _ready():
	area_entered.connect(_on_area_entered)
	
	# Set up the AudioStreamPlayer with process mode Always
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(audio_player)


func receive_value(value):
	pass

func _on_area_entered(area):
	if area.name in ["Sales_Collision_Detector", "Property_Collision_Detector", "Income_Collision_Detector", "Golden_Collision_Detector"]:
		
		var result = Global_Variables.calculate_difference(Global_Variables.money, area.get_value())
		
		var random_index = randi() % 5
		
		# Play hit sfx
		$AudioStreamPlayer.stream = load(Global_Variables.hurt_voice_lines[random_index])
		$AudioStreamPlayer.volume_db = -3
		$AudioStreamPlayer.play()
		
		if self.get_instance_id() < area.get_instance_id():
			area.receive_value(result)
			receive_value(-result)
			Global_Variables.money -= result
		
	elif area.name == "Asteroid" or area.name == "Space_Tax_Special":
		print("asteroidYIKES")
		Global_Variables.space_explosion_animation()
		get_tree().paused = true
		var parent = get_parent()
		var player_sprite = parent.get_node_or_null("Node2D/Player_Sprite")
		var shot_sprite = parent.get_node_or_null("Node2D/Shot_In_Hand_Sprite")
		
		player_sprite.visible = false
		shot_sprite.visible = false
		
		await get_tree().create_timer(0.5).timeout # Wait for explosion animation to finish
		audio_player.stream = load("res://Finished_Assets/Voice_Line_Assets/Misc_Voice_Lines/Todd_Pain.wav")
		audio_player.volume_db += 5
		audio_player.play()
		await get_tree().create_timer(3.0).timeout
		get_parent().get_parent().remove_all_audio_effects()
		var gameplay_scene = load("res://UI + Menus + Scenes/Gameplay/gameplay_scene.tscn")
		get_tree().paused = false
		get_tree().change_scene_to_packed(gameplay_scene)
		player_sprite.visible = true
		shot_sprite.visible = true
		
	elif area.name == "Space_Theme_Stopper":
		%Camera2D.move_camera_down()
	
	elif area.name == "TODD": # Todd Jumpscare
		get_parent().get_parent().spawn_jumpscare()
		get_parent().get_parent().remove_all_audio_effects()
	
	elif area.name == "Enter_Earth": # Space Ending
		get_parent().get_parent().fade_out()
		%Camera2D.zoom_in()
		var victory_scene = load("res://UI + Menus + Scenes/Victory_Scene/victory_scene.tscn")
		await get_tree().create_timer(5.0).timeout
		get_parent().get_parent().remove_all_audio_effects()
		Global_Variables.space_win = true
		get_tree().change_scene_to_packed(victory_scene)
		
func _on_area_exited(area):
	if area.name == "Space_Theme_Stopper":
		%Camera2D.move_camera_up()
	

		
