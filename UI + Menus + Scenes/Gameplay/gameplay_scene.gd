extends Node2D

var default_camera: Camera2D
var instant_replay_camera: Camera2D
var timer: Timer
var elapsed_time: float = 0.0

var dead = false # If Todd is dead

@export var stat_progression_time = 500.0 # Time until stats get to max

# Store initial and target values
var initial_values = {
		"sales_tax_health": 20.0,
		"property_tax_health": 40.0,
		"income_tax_health": 100.0,
		"golden_tax_health": 334.0,
		"sales_tax_shot_health": 0.1,
		"property_tax_shot_health": 0.3,
		"income_tax_shot_health": 1.0,
		"golden_tax_shot_health": 4.0,
		
		"sales_tax_exp": 0.8,
		"property_tax_exp": 2.0,
		"income_tax_exp": 5.0,
		"golden_tax_exp": 50.0,
}


var target_values = {
		"sales_tax_health": 375.0,
		"property_tax_health": 750.0,
		"income_tax_health": 2000.0,
		"golden_tax_health": 7500.0,
		
		"sales_tax_shot_health": 5.0,
		"property_tax_shot_health": 15.0,
		"income_tax_shot_health": 100.0,
		"golden_tax_shot_health": 1000.0,
		
		"sales_tax_exp": 35.0,
		"property_tax_exp": 70.0,
		"income_tax_exp": 180.0,
		"golden_tax_exp": 800.0,
}

func _ready():
		get_tree().paused = false
		# Setting Global Variables to Default values
		Global_Variables.money = 10.0 # Broke Todd ;(
		
		Global_Variables.Coin_Variant = 0
		Global_Variables.Dollar_Variant = 0
		Global_Variables.Check_Variant = 0
		Global_Variables.Current_Shot = 0
		
		Global_Variables.player_exp = 0.0
		Global_Variables.player_job = 0
		
		Global_Variables.sales_tax_health = 40.0
		Global_Variables.property_tax_health = 80.0
		Global_Variables.income_tax_health = 200.0
		Global_Variables.golden_tax_health = 667.0
		
		Global_Variables.sales_tax_shot_health = 0.25
		Global_Variables.property_tax_shot_health = 0.5
		Global_Variables.income_tax_shot_health = 1.25
		Global_Variables.golden_tax_shot_health = 4.0
		
		Global_Variables.sales_tax_exp = 1.0
		Global_Variables.property_tax_exp = 3.0
		Global_Variables.income_tax_exp = 5.0
		Global_Variables.golden_tax_exp = 50.0
		
		# Get a reference to the default camera
		default_camera = get_viewport().get_camera_2d()
		
		# Get a reference to the instant replay camera
		instant_replay_camera = get_node("Physics_Objects/Car_1/Camera_1")
		
		# Ensure the instant replay camera exists
		if not instant_replay_camera:
				push_error("Instant replay camera not found at path: Physics_Objects/Car_1/Camera_1")
				return
		
		# Create and set up the timer
		timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = 8.0
		timer.timeout.connect(_on_timer_timeout)
		add_child(timer)
	
	
var one_second_timer = 0.0

func _process(delta):
		one_second_timer += delta
		if one_second_timer >= 1.0:
				Global_Variables.money += Global_Variables.player_job_values[Global_Variables.player_job][1]
				one_second_timer = 0.0
		# Update the progression
		if elapsed_time < stat_progression_time:
				elapsed_time += delta
				
				# Calculate the interpolation factor (0 to 1)
				var t = elapsed_time / stat_progression_time
				t = clamp(t, 0.0, 1.0)
				
				# Update each value
				Global_Variables.sales_tax_health = lerp(
						initial_values.sales_tax_health,
						target_values.sales_tax_health,
						t
				)
				
				Global_Variables.property_tax_health = lerp(
						initial_values.property_tax_health,
						target_values.property_tax_health,
						t
				)
				
				Global_Variables.income_tax_health = lerp(
						initial_values.income_tax_health,
						target_values.income_tax_health,
						t
				)
				
				Global_Variables.golden_tax_health = lerp(
						initial_values.golden_tax_health,
						target_values.golden_tax_health,
						t
				)
				
				# Add tax shot health lerp updates
				Global_Variables.sales_tax_shot_health = lerp(
						initial_values.sales_tax_shot_health,
						target_values.sales_tax_shot_health,
						t
				)
				
				Global_Variables.property_tax_shot_health = lerp(
						initial_values.property_tax_shot_health,
						target_values.property_tax_shot_health,
						t
				)
				
				Global_Variables.income_tax_shot_health = lerp(
						initial_values.income_tax_shot_health,
						target_values.income_tax_shot_health,
						t
				)
				
				Global_Variables.golden_tax_shot_health = lerp(
						initial_values.golden_tax_shot_health,
						target_values.golden_tax_shot_health,
						t
				)
				
				Global_Variables.sales_tax_exp = lerp(
						initial_values.sales_tax_exp,
						target_values.sales_tax_exp,
						t
				)

				Global_Variables.property_tax_exp = lerp(
						initial_values.property_tax_exp,
						target_values.property_tax_exp,
						t
				)
				
				Global_Variables.income_tax_exp = lerp(
						initial_values.income_tax_exp,
						target_values.income_tax_exp,
						t
				)
				
				Global_Variables.golden_tax_exp = lerp(
						initial_values.golden_tax_exp,
						target_values.golden_tax_exp,
						t
				)
				check_level_up()
		if Input.is_action_just_pressed("pause"):
				if Global_Variables.is_paused == false:
						print("opening pause menu   ", Global_Variables.is_paused)
						
						# Create tween that processes even when paused
						var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
						
						# Fade out Gameplay theme
						tween.parallel().tween_property(%Gameplay_Theme, "volume_db", -30.0, 2.0)
						# Fade in Pause theme
						tween.parallel().tween_property(%Pause_Theme, "volume_db", 4.0, 1.0)
						
						%Menu_Spawner.pause_menu()
						print(Global_Variables.is_paused)
						Global_Variables.is_paused = true
func unpausing():
		
		# Create tween that processes even when paused
		var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		
		# Fade in Gameplay theme
		tween.parallel().tween_property(%Gameplay_Theme, "volume_db", 0.0, 1.0) # Assuming 0.0 is your default volume
		# Fade out Pause theme
		tween.parallel().tween_property(%Pause_Theme, "volume_db", -30.0, 2.0)
		
		print(Global_Variables.is_paused)
		
func unupgrading():
		
		# Create tween that processes even when paused
		var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
		
		# Fade in Gameplay theme
		tween.parallel().tween_property(%Gameplay_Theme, "volume_db", 0.0, 1.0) # Assuming 0.0 is your default volume
		# Fade out Pause theme
		tween.parallel().tween_property(%Upgrade_Theme, "volume_db", -30.0, 2.0)
		
		print(Global_Variables.is_paused)

func tax_evasion_ending_start():
	%Menu_Spawner.tax_evasion()


func check_level_up():
	if Global_Variables.player_job_values[Global_Variables.player_job][0] <= Global_Variables.player_exp and Global_Variables.player_job != 5:
		Global_Variables.level_up()
	elif Global_Variables.money >= 1000000000:
		Global_Variables.victory()
	elif Global_Variables.money <= 0:
		if not dead:
			dead = true
			Global_Variables.mute_game_theme(true)
			Global_Variables.money = 0
			await get_tree().create_timer(0.1).timeout
			Global_Variables.explosion_animation()
			get_tree().paused = true
			
			var player_sprite = $Player.get_node_or_null("Node2D/Player_Sprite")
			var shot_sprite = $Player.get_node_or_null("Node2D/Shot_In_Hand_Sprite")
			
			player_sprite.visible = false
			shot_sprite.visible = false
			
			var random_index = randi() % 5
			
			print("Random death index:  ", random_index)
			
			await get_tree().create_timer(0.5).timeout # Wait for explosion animation to finish
			$AudioStreamPlayer.stream = load(Global_Variables.death_voice_lines[random_index])
			$AudioStreamPlayer.play()
				
			await get_tree().create_timer(4.0).timeout
			Global_Variables.defeat()
			player_sprite.visible = true
			shot_sprite.visible = true

func switch_to_instant_replay_camera():
		# Switch to the instant replay camera
		instant_replay_camera.make_current()
		
		# Start the timer
		timer.start()

func _on_timer_timeout():
		# Switch back to the default camera
		default_camera.make_current()
