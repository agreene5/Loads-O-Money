# Add variables that are needed by multiple scripts here (ex. Money)
extends Node

var deceleration = 5.0 # Defines deceleration of bullets over time (if you're using a rigidbody2D you can use the damp value under the Linear tab instead
var money = 20.0 # Defines the players money value (default value starts at $20)
var test_money = 20.0

var sales_tax_health = 10.0 # Base health values for each tax enemy 
var property_tax_health = 15.0
var income_tax_health = 50.0
var golden_tax_health = 1500.0

var sales_tax_exp = 1.0 # Base exp values for each tax enemy
var property_tax_exp = 3.0
var income_tax_exp = 5.0
var golden_tax_exp = 500.0

var sales_tax_shot_health = 2.0
var property_tax_shot_health = 5.0
var income_tax_shot_health = 20.0
var golden_tax_shot_health = 50.0

var is_paused = false
var game_just_started = true
var game_just_just_started = true

var polo_rob_range = false

var button_hovered = false

var real_life = false

var player_exp = 0.0 # The amount of EXP Todd (the player) has
var player_job = 0 # Defines the players current job | 0: Unemployed, 1: Fast Food Worker, ... 5: Tech Giant CEO
var player_job_values = { # Defines player job stat values
	# [0-Exp needed to move up a job, 1-money you earn/second, 2-dash cooldown, 3-dash speed, 4-dash time, 5-speed, 6-sprite, 7-red flash threshold
	0: [3.0, 0.00, 2.0, 400.0, 0.5, 200.0, "res://Finished_Assets/Player_Body_Assets/Unemployed_Todd.png", 1.50],
	1: [50.0, 0.4, 1.5, 550.0, 0.4, 230.0, "res://Finished_Assets/Player_Body_Assets/Fast_Food_Worker_Todd.png", 2.00],
	2: [500.0, 6.00, 1.3, 700.0, 0.3, 267.0, "res://Finished_Assets/Player_Body_Assets/Restaurant_Manager_Todd.png", 20.00],
	3: [2000.0, 50.00, 1.0, 1000.0, 0.2, 300.0, "res://Finished_Assets/Player_Body_Assets/Regional_Operations_Manager_Todd.png", 100.00],
	4: [5000.0, 200.00, 0.8, 1500.0, 0.15, 330.0, "res://Finished_Assets/Player_Body_Assets/CEO_Todd.png", 500.00],
	5: [0.0, 50000000.00, 0.1, 2500.0, 0.1, 500.0, "res://Finished_Assets/Player_Body_Assets/Tech_Giant_CEO_Todd.png", 200.00],
}
func level_up():
	player_job += 1
	var player = get_tree().current_scene.get_node("Player")
	player.level_up()

func victory(): # AKA Billionare Status
	get_tree().paused = true
	print("YOU WIN WOW YOU'RE A BILLIONARE")
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Victory_Scene/victory_scene.tscn")
	
func defeat(): # AKA Bankrupcy
	get_tree().paused = true
	print("Broke :(")
	get_tree().change_scene_to_file("res://UI + Menus + Scenes/Bankrupcy_Scene/bankrupcy_scene.tscn")

var SHOT_HEALTH = { # The health of all shot types
	"Penny_Collision_Detector": 1.5,
	"Nickel_Collision_Detector": 6.0,
	"Dime_Collision_Detector": 9.0,
	"Quarter_Collision_Detector": 17.5,
	
	"Washington_Collision_Detector": 30.0,
	"Lincoln_Collision_Detector": 180.0,
	"Jackson_Collision_Detector": 500.0,
	"Grant_Collision_Detector": 1000.0,
	
	"100_Collision_Detector": 500.0,
	"200_Collision_Detector": 2000.0,
	"500_Collision_Detector": 4000.0,
	"1000_Collision_Detector": 7000.0,
}

signal Coin_Variant_changed

var Coin_Variant = 0 # Determines the coin variant the user has | 0: Penny, 1: Nickel, 2: Dime, 3: Quarter

func set_Coin_Variant(new_value):
		Coin_Variant = new_value
		emit_signal("Coin_Variant_changed")

var Dollar_Variant = 0 # Determines the dollar variant the user has | 0: Washington, 1: Lincoln, 2: Jackson, 3: Grant

signal Check_Variant_changed
var Check_Variant = 0 # Determines the check variant the user has | 0: $100 Check, 1: $200 Check, 2: $500 Check, 3: $1000 CHeck

func set_Check_Variant(new_value):
		Check_Variant = new_value
		emit_signal("Check_Variant_changed")


signal Current_Shot_changed
var Current_Shot = 0 # Determines what shot the player is currently using | 0: Coin, 1: Dollar, 2: Check
func set_Current_Shot(new_value):
		Current_Shot = new_value
		emit_signal("Current_Shot_changed")

var player_position # used to let other scripts read player position
var player_position_space # used to see space player position

var space_win = true

var star_1 = false # Billionare ending
var star_2 = false # Tax fraud ending
var star_3 = false # Space ending

func explosion_animation(): #spawns explosion animation on players position
	var explosion_scene = load("res://Misc/explosion_animation.tscn")
	var explosion_instance = explosion_scene.instantiate()
	explosion_instance.global_position = player_position
	get_tree().root.add_child(explosion_instance)
	await get_tree().create_timer(1.3).timeout # Waiting for sfx to finish before despawning
	explosion_instance.queue_free()
	
func space_explosion_animation(): #spawns explosion animation on space player position
	var explosion_scene = load("res://Misc/explosion_animation.tscn")
	var explosion_instance = explosion_scene.instantiate()
	explosion_instance.global_position = player_position_space
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

func irs_aligator_death_animation(): #spawns explosion animation on players position
	var aligator_scene = load("res://Misc/IRS_aligator_death_animation.tscn")
	var aligator_instance = aligator_scene.instantiate()
	aligator_instance.global_position = player_position
	get_tree().root.add_child(aligator_instance)
	await get_tree().create_timer(1.0).timeout # Waiting for sfx to finish before despawning
	aligator_instance.queue_free()

func exp_label(exp_gained): # Spawns EXP label on player when an enemy is destroyed
	var current_scene = get_tree().current_scene
	var player = current_scene.get_node("Player")
	player.exp_amount(exp_gained)

var MLG_videos = ["res://UI + Menus + Scenes/MLG_Scene/UnemployedCropped.ogv",
"res://UI + Menus + Scenes/MLG_Scene/FastFoodCropped.ogv",
"res://UI + Menus + Scenes/MLG_Scene/ManagerCropped.ogv",
"res://UI + Menus + Scenes/MLG_Scene/OperationsCropped.ogv",
"res://UI + Menus + Scenes/MLG_Scene/CEOMLGDeath_Resized.ogv",
"res://UI + Menus + Scenes/MLG_Scene/CEOCropped.ogv"]

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

var hurt_voice_lines = [
	"res://Finished_Assets/Voice_Line_Assets/Hurt_Voice_Lines/Hurt_Voice_Lines_1.wav",
	"res://Finished_Assets/Voice_Line_Assets/Hurt_Voice_Lines/Hurt_Voice_Lines_2.wav",
	"res://Finished_Assets/Voice_Line_Assets/Hurt_Voice_Lines/Hurt_Voice_Lines_3.wav",
	"res://Finished_Assets/Voice_Line_Assets/Hurt_Voice_Lines/Hurt_Voice_Lines_4.wav",
	"res://Finished_Assets/Voice_Line_Assets/Hurt_Voice_Lines/Hurt_Voice_Lines_5.wav"
]

var death_voice_lines = [
	"res://Finished_Assets/Voice_Line_Assets/Death_Voice_Lines/Death_Voice_Lines_1.wav",
	"res://Finished_Assets/Voice_Line_Assets/Death_Voice_Lines/Death_Voice_Lines_2.wav",
	"res://Finished_Assets/Voice_Line_Assets/Death_Voice_Lines/Death_Voice_Lines_3.wav",
	"res://Finished_Assets/Voice_Line_Assets/Death_Voice_Lines/Death_Voice_Lines_4.wav",
	"res://Finished_Assets/Voice_Line_Assets/Death_Voice_Lines/Death_Voice_Lines_5.wav",
	"res://Finished_Assets/Voice_Line_Assets/Death_Voice_Lines/Death_Voice_Lines_6.wav"
]

var bootscreen_voice_lines = [
	"res://Finished_Assets/Voice_Line_Assets/Bootscreen_Voice_Lines/Bootscreen_Voice_Lines_1.wav",
	"res://Finished_Assets/Voice_Line_Assets/Bootscreen_Voice_Lines/Bootscreen_Voice_Lines_2.wav",
	"res://Finished_Assets/Voice_Line_Assets/Bootscreen_Voice_Lines/Bootscreen_Voice_Lines_3.wav",
	"res://Finished_Assets/Voice_Line_Assets/Bootscreen_Voice_Lines/Bootscreen_Voice_Lines_4.wav",
	"res://Finished_Assets/Voice_Line_Assets/Bootscreen_Voice_Lines/Bootscreen_Voice_Lines_5.wav",
	"res://Finished_Assets/Voice_Line_Assets/Bootscreen_Voice_Lines/Bootscreen_Voice_Lines_6.wav",
	"res://Finished_Assets/Voice_Line_Assets/Bootscreen_Voice_Lines/Bootscreen_Voice_Lines_7.wav",
	"res://Finished_Assets/Voice_Line_Assets/Bootscreen_Voice_Lines/Bootscreen_Voice_Lines_8.wav"
]

var comic_voice_lines = [
	["res://Finished_Assets/Voice_Line_Assets/Comic_Voice_Lines/Comic_1_Line_1.mp3",
	"res://Finished_Assets/Voice_Line_Assets/Comic_Voice_Lines/Comic_1_Line_2.mp3",
	"res://Finished_Assets/Voice_Line_Assets/Comic_Voice_Lines/Comic_1_Line_3.mp3",
	"res://Finished_Assets/Voice_Line_Assets/Comic_Voice_Lines/Comic_1_Line_4.mp3"],
	["res://Finished_Assets/Voice_Line_Assets/Comic_Voice_Lines/Comic_2_Line_1.mp3",
	"res://Finished_Assets/Voice_Line_Assets/Comic_Voice_Lines/Comic_2_Line_2.mp3"],
	["res://Finished_Assets/Voice_Line_Assets/Comic_Voice_Lines/Comic_3_Line_1.mp3",
	"res://Finished_Assets/Voice_Line_Assets/Comic_Voice_Lines/Comic_3_Line_2.mp3"]
]

var todd_random_voice_lines = [
	"res://Finished_Assets/Voice_Line_Assets/Misc_Voice_Lines/Todd_Random_Voice_1.mp3",
	"res://Finished_Assets/Voice_Line_Assets/Misc_Voice_Lines/Todd_Random_Voice_2.mp3",
	"res://Finished_Assets/Voice_Line_Assets/Misc_Voice_Lines/Todd_Random_Voice_3.mp3",
	"res://Finished_Assets/Voice_Line_Assets/Misc_Voice_Lines/Todd_Random_Voice_4.mp3",
	"res://Finished_Assets/Voice_Line_Assets/Misc_Voice_Lines/Todd_Random_Voice_5.mp3",
	"res://Finished_Assets/Voice_Line_Assets/Misc_Voice_Lines/Todd_Random_Voice_6.mp3"
]


signal mute_gameplay_theme(mute)
func mute_game_theme(mute: bool):
	emit_signal("mute_gameplay_theme", mute)
	
signal space_abduction_triggered
