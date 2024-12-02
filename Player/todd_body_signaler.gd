extends Area2D

@onready var audio_player = AudioStreamPlayer.new()
var is_replaying = false
var tax_evasion_timer: Timer

func _ready():
	area_entered.connect(_on_area_entered)
	
	# Set up the AudioStreamPlayer with process mode Always
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(audio_player)
	


	tax_evasion_timer = Timer.new()
	tax_evasion_timer.one_shot = true
	tax_evasion_timer.wait_time = 120.0
	tax_evasion_timer.timeout.connect(tax_evasion)  # Connect directly to evading
	add_child(tax_evasion_timer)
	
	tax_evasion_timer.start()

func tax_evasion():
	print("taxevasion going")
	Global_Variables.mute_game_theme(true)
	get_parent().get_parent().tax_evasion_ending_start()


func receive_value(value):
	pass

func _on_area_entered(area):
	if area.name in ["Sales_Collision_Detector", "Property_Collision_Detector", "Income_Collision_Detector", "Golden_Collision_Detector"]:
		tax_evasion_timer.start()
		
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
		
		
		
	elif area.name == "Death_Area2D": # Drowning Death
		Global_Variables.mute_game_theme(true)
		Global_Variables.irs_aligator_death_animation()
		get_tree().paused = true
		
		var parent = get_parent()
		var player_sprite = parent.get_node_or_null("Node2D/Player_Sprite")
		var shot_sprite = parent.get_node_or_null("Node2D/Shot_In_Hand_Sprite")
		
		player_sprite.visible = false
		shot_sprite.visible = false
		
		await get_tree().create_timer(0.6).timeout # Wait for explosion animation to finish
		audio_player.stream = load("res://Finished_Assets/Voice_Line_Assets/Death_Voice_Lines/Death_Voice_Lines_1.wav")
		audio_player.volume_db = 5  # Increase volume by 3 decibels
		audio_player.play()
		
		await get_tree().create_timer(3.3).timeout
		get_tree().change_scene_to_file("res://UI + Menus + Scenes/Drowned_Menu/Drowned_Scene.tscn")
		player_sprite.visible = true
		shot_sprite.visible = true
		
	elif area.name == "Car_Death_Box": # Car death
		Global_Variables.mute_game_theme(true)
		Global_Variables.explosion_animation()
		get_tree().paused = true
		
		var parent = get_parent()
		var player_sprite = parent.get_node_or_null("Node2D/Player_Sprite")
		var shot_sprite = parent.get_node_or_null("Node2D/Shot_In_Hand_Sprite")
		
		player_sprite.visible = false
		shot_sprite.visible = false
		
		await get_tree().create_timer(0.5).timeout # Wait for explosion animation to finish
		audio_player.stream = load("res://Finished_Assets/Voice_Line_Assets/Misc_Voice_Lines/Todd_Pain.wav")
		audio_player.volume_db = 5
		audio_player.play()
		
		await get_tree().create_timer(3.0).timeout
		get_tree().change_scene_to_file("res://UI + Menus + Scenes/MLG_Scene/mlg_scene.tscn")
		player_sprite.visible = true
		shot_sprite.visible = true
	elif area.name == "Saul_Death": # Saul steals yo money 
		Global_Variables.money -= Global_Variables.money/3
	elif area.name == "Polo_Detector": # You able to Rob Polo :OOOO
		pass
		
		
