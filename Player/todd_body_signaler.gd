extends Area2D

@onready var audio_player = AudioStreamPlayer.new()
var is_replaying = false
var can_trigger_car_death = true  # New variable to track cooldown
var car_death_cooldown_timer: Timer  # New timer for cooldown

func _ready():
	area_entered.connect(_on_area_entered)
	
	# Set up the AudioStreamPlayer with process mode Always
	audio_player.process_mode = Node.PROCESS_MODE_ALWAYS
	add_child(audio_player)
	
	# Set up cooldown timer
	car_death_cooldown_timer = Timer.new()
	car_death_cooldown_timer.one_shot = true
	car_death_cooldown_timer.wait_time = 3.0
	car_death_cooldown_timer.timeout.connect(_on_cooldown_timeout)
	add_child(car_death_cooldown_timer)

func _on_cooldown_timeout():
	can_trigger_car_death = true

func _on_area_entered(area):
	#if area
	
	if area.name == "Death_Area2D": # Drowning Death
		Global_Variables.explosion_animation()
		get_tree().paused = true
		
		var parent = get_parent()
		var player_sprite = parent.get_node_or_null("Player_Sprite")
		var shot_sprite = parent.get_node_or_null("Shot_In_Hand_Sprite")
		
		player_sprite.visible = false
		shot_sprite.visible = false
		
		await get_tree().create_timer(0.5).timeout # Wait for explosion animation to finish
		audio_player.stream = load("res://Finished_Assets/Voice_Line_Assets/Death_Voice_Lines_1.wav")
		audio_player.volume_db += 3  # Increase volume by 3 decibels
		audio_player.play()
		
		await get_tree().create_timer(3.3).timeout
		get_tree().change_scene_to_file("res://UI + Menus + Scenes/Drowned_Menu/Drowned_Scene.tscn")
		player_sprite.visible = true
		shot_sprite.visible = true
		
	if area.name == "Car_Death_Box" and can_trigger_car_death: # Car death
		print("CarDeath")
		can_trigger_car_death = false  # Disable triggering until cooldown is over
		car_death_cooldown_timer.start()  # Start the cooldown timer
		
		if not is_replaying:
			Global_Variables.explosion_animation()
			Global_Variables.MLG_video()
			get_tree().paused = true
			
			var parent = get_parent()
			var player_sprite = parent.get_node_or_null("Player_Sprite")
			var shot_sprite = parent.get_node_or_null("Shot_In_Hand_Sprite")
			
			player_sprite.visible = false
			shot_sprite.visible = false
			
			await get_tree().create_timer(4.0).timeout # Wait for beat to drop
			is_replaying = true
			get_tree().paused = false
			player_sprite.visible = true
			shot_sprite.visible = true
			Global_Variables.instant_replay_functions()
			await get_tree().create_timer(8.0).timeout # Waiting for replay to end 
			player_sprite.visible = true
			shot_sprite.visible = true
			
		elif is_replaying:
			Global_Variables.explosion_animation()
			
			var parent = get_parent()
			var player_sprite = parent.get_node_or_null("Player_Sprite")
			var shot_sprite = parent.get_node_or_null("Shot_In_Hand_Sprite")
			player_sprite.visible = false
			shot_sprite.visible = false
			
			await get_tree().create_timer(0.5).timeout # Wait for explosion animation to finish
			
			is_replaying = false
