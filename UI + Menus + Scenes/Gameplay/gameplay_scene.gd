extends Node2D

var default_camera: Camera2D
var instant_replay_camera: Camera2D
var timer: Timer
var elapsed_time: float = 0.0

@export var stat_progression_time = 600.0 # In 10 minutes the spawning gets pretty much impossible to take on

# Store initial and target values
var initial_values = {
		"sales_tax_health": 50.0,
		"property_tax_health": 100.0,
		"income_tax_health": 300.0,
		
		"sales_tax_shot_health": 2.0,
		"property_tax_shot_health": 5.0,
		"income_tax_shot_health": 20.0,
		
		"sales_tax_exp": 1.0,
		"property_tax_exp": 3.0,
		"income_tax_exp": 5.0
}

var target_values = {
		"sales_tax_health": 300.0,
		"property_tax_health": 400.0,
		"income_tax_health": 700.0,
		
		"sales_tax_shot_health": 10.0,
		"property_tax_shot_health": 25.0,
		"income_tax_shot_health": 100.0,
		
		"sales_tax_exp": 50.0,
		"property_tax_exp": 150.0,
		"income_tax_exp": 250.0
}

func _ready():
		get_tree().paused = false
		# Setting Global Variables to Default values
		Global_Variables.money = 50000.0 # Broke Todd ;(
		
		Global_Variables.Coin_Variant = 0
		Global_Variables.Dollar_Variant = 0
		Global_Variables.Check_Variant = 0
		Global_Variables.Current_Shot = 0
		
		Global_Variables.player_exp = 0.0
		Global_Variables.player_job = 0
		
		Global_Variables.sales_tax_health = 10.0
		Global_Variables.property_tax_health = 15.0
		Global_Variables.income_tax_health = 50.0
		
		Global_Variables.sales_tax_shot_health = 1.0
		Global_Variables.property_tax_shot_health = 3.0
		Global_Variables.income_tax_shot_health = 5.0
		
		Global_Variables.sales_tax_exp = 1.0
		Global_Variables.property_tax_exp = 3.0
		Global_Variables.income_tax_exp = 5.0
		
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
				check_level_up()
		if Input.is_action_just_pressed("pause") and Global_Variables.is_paused == false:  # Added pause check
			print("opening pause menu   ", Global_Variables.is_paused)
			%Menu_Spawner.pause_menu()
			print(Global_Variables.is_paused)
			

func check_level_up():
	if Global_Variables.player_job_values[Global_Variables.player_job][0] <= Global_Variables.player_exp and Global_Variables.player_job != 5:
		Global_Variables.level_up()
	elif Global_Variables.money >= 1000000000:
		Global_Variables.victory()
	elif Global_Variables.money <= 0:
		Global_Variables.money = 0
		Global_Variables.explosion_animation()
		get_tree().paused = true
		
		var player_sprite = $Player.get_node_or_null("Player_Sprite")
		var shot_sprite = $Player.get_node_or_null("Shot_In_Hand_Sprite")
		
		player_sprite.visible = false
		shot_sprite.visible = false
		
		var random_index = randi() % 5
		
		print("Random death index:  ", random_index)
		
		
		await get_tree().create_timer(0.5).timeout # Wait for explosion animation to finish
		$AudioStreamPlayer.stream = load(Global_Variables.death_voice_lines[random_index])
		$AudioStreamPlayer.volume_db += 5
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
