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
		
		"sales_tax_exp": 1.0,
		"property_tax_exp": 3.0,
		"income_tax_exp": 5.0
}

var target_values = {
		"sales_tax_health": 300.0,
		"property_tax_health": 400.0,
		"income_tax_health": 700.0,
		
		"sales_tax_exp": 50.0,
		"property_tax_exp": 150.0,
		"income_tax_exp": 250.0
}

func _ready():
		print(stat_progression_time, "String")
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
	

func _process(delta):
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

func check_level_up():
	if Global_Variables.player_job_values[Global_Variables.player_job][0] <= Global_Variables.player_exp and Global_Variables.player_job != 5:
		Global_Variables.level_up()
	elif Global_Variables.money >= 1000000000:
		Global_Variables.victory()

func switch_to_instant_replay_camera():
		# Switch to the instant replay camera
		instant_replay_camera.make_current()
		
		# Start the timer
		timer.start()

func _on_timer_timeout():
		# Switch back to the default camera
		default_camera.make_current()
