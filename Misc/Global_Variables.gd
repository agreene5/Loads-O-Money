# Add variables that are needed by multiple scripts here (ex. Money)
extends Node

var deceleration = 5.0 # Defines deceleration of bullets over time (if you're using a rigidbody2D you can use the damp value under the Linear tab instead

var money = 100000.0 # Defines the players money value (default value starts at $10)

var sales_tax_health = 10.0 # Base health values for each tax enemy 
var property_tax_health = 15.0
var income_tax_health = 50.0

var sales_tax_exp = 1.0 # Base exp values for each tax enemy
var property_tax_exp = 3.0
var income_tax_exp = 5.0

var player_exp = 0.0 # The amount of EXP Todd (the player) has
var player_job = 0 # Defines the players current job | 0: Unemployed, 1: Fast Food Worker, ... 5: Tech Giant CEO
var player_job_values = { # Defines player job stat values
	# [0-Exp needed to move up a job, 1-money you earn/second, 2-dash cooldown, 3-dash speed, 4-dash time, 5-speed, 6-sprite 
	0: [3.0, 0.00, 2.0, 300.0, 0.5, 200.0, "res://Finished_Assets/Player_Body_Assets/Unemployed_Todd.png"],
	1: [20.0, 0.05, 1.5, 400.0, 0.4, 230.0, "res://Finished_Assets/Player_Body_Assets/Fast_Food_Worker_Todd.png"],
	2: [200.0, 0.50, 1.3, 600.0, 0.3, 267.0, "res://Finished_Assets/Player_Body_Assets/Restaurant_Manager_Todd.png"],
	3: [1000.0, 5.00, 1.0, 1000.0, 0.2, 300.0, "res://Finished_Assets/Player_Body_Assets/Regional_Operations_Manager_Todd.png"],
	4: [10000.0, 50.00, 0.8, 1500.0, 0.15, 330.0, "res://Finished_Assets/Player_Body_Assets/CEO_Todd.png"],
	5: [0.0, 50000000.00, 0.1, 2500.0, 0.1, 500.0, "res://Finished_Assets/Player_Body_Assets/Tech_Giant_CEO_Todd.png"],
}
func level_up():
	player_job += 1
	var player = get_tree().current_scene.get_node("Player")
	player.level_up()
func victory(): # AKA Billionare Status
	print("YOU WIN WOW YOU'RE A BILLIONARE")

var SHOT_HEALTH = { # The health of all shot types
	"Penny_Collision_Detector": 1.0,
	"Nickel_Collision_Detector": 3.0,
	"Dime_Collision_Detector": 8.0,
	"Quarter_Collision_Detector": 20.0,
	
	"Washington_Collision_Detector": 10.0,
	"Lincoln_Collision_Detector": 30.0,
	"Jackson_Collision_Detector": 80.0,
	"Grant_Collision_Detector": 200.0,
	
	"100_Collision_Detector": 100.0,
	"200_Collision_Detector": 300.0,
	"500_Collision_Detector": 800.0,
	"1000_Collision_Detector": 2000.0,
}

signal Coin_Variant_changed

var Coin_Variant = 3 # Determines the coin variant the user has | 0: Penny, 1: Nickel, 2: Dime, 3: Quarter

func set_Coin_Variant(new_value):
		Coin_Variant = new_value
		emit_signal("Coin_Variant_changed")

var Dollar_Variant = 1 # Determines the dollar variant the user has | 0: Washington, 1: Lincoln, 2: Jackson, 3: Grant

signal Check_Variant_changed
var Check_Variant = 1 # Determines the check variant the user has | 0: $100 Check, 1: $200 Check, 2: $500 Check, 3: $1000 CHeck

func set_Check_Variant(new_value):
		Check_Variant = new_value
		emit_signal("Check_Variant_changed")


signal Current_Shot_changed
var Current_Shot = 0 # Determines what shot the player is currently using | 0: Coin, 1: Dollar, 2: Check
func set_Current_Shot(new_value):
		Current_Shot = new_value
		emit_signal("Current_Shot_changed")

var player_position # used to let other scripts read player position


func explosion_animation(): #spawns explosion animation on players position
	var explosion_scene = load("res://Misc/explosion_animation.tscn")
	var explosion_instance = explosion_scene.instantiate()
	explosion_instance.global_position = player_position
	get_tree().root.add_child(explosion_instance)

	await get_tree().create_timer(1.3).timeout # Waiting for sfx to finish before despawning
	explosion_instance.queue_free()

func explosion_tax_animation(tax_position, scale): #spawns explosion animation on tax position
	var explosion_scene = load("res://Misc/explosion_animation.tscn")
	var explosion_instance = explosion_scene.instantiate()
	explosion_instance.global_position = tax_position
	explosion_instance.scale = Vector2(5*scale, 5*scale) # Different scale depending on enemy size
	get_tree().root.add_child(explosion_instance)
	await get_tree().create_timer(1.3).timeout # Waiting for sfx to finish before despawning
	explosion_instance.queue_free()
	
func collision_animation(physics_position): #spawns collision animation on physic objects position
	var collision_scene = load("res://Misc/collision_animation.tscn")
	var collision_instance = collision_scene.instantiate()
	collision_instance.global_position = physics_position
	get_tree().root.add_child(collision_instance)
	await get_tree().create_timer(0.4).timeout # Waiting for sfx to finish before despawning
	collision_instance.queue_free()

func MLG_video(): # Plays MLG video for instant replay
		var MLG_scene = load("res://UI + Menus + Scenes/MLG_Scene/MLG_Instant_Replay_Video.tscn")
		var MLG_instance = MLG_scene.instantiate()
		get_tree().root.add_child(MLG_instance)
		await get_tree().create_timer(12.0).timeout # Waiting for replay to finish
		MLG_instance.queue_free()
		get_tree().reload_current_scene() # Resetting gameplay scene after you die

var Car_Stored_Positions = [] # ALl stored states are for the instant replay
var Car_Stored_States = []
var Player_Stored_Inputs = []
var Player_Stored_States = []

func instant_replay_functions(): # Calls the 3 functions that make the camera switch, the player replay movement, and the car replay movement
	var current_scene = get_tree().current_scene
	current_scene.switch_to_instant_replay_camera()
	current_scene.get_node("Gameplay_Theme").stop()

	var player = current_scene.get_node("Player")
	player.start_replay()

	var car = current_scene.get_node("Physics_Objects/Car_1")
	car.start_replay()

func hit(area, my_value): # For tax enemy health
	print(my_value)
	return my_value

func calculate_difference(broadcast_value,receive_value): # For tax enemy health
	var difference = receive_value - broadcast_value
	if difference >0:
		return difference
	else:
		return receive_value


func calculate_collision(broadcast_value,receive_value): # For tax enemy health
	if broadcast_value > receive_value:
		return broadcast_value/2
	else:
		return receive_value/2
