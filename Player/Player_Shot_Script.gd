# This script defines the 3 shot types for the character, which are cycled through by pressing
# the "E" key. It also subtracts from the money variable an amount determined by the shot type
# every time you shoot.

extends Node2D

var CoinShotPenny = preload("res://Coins/player_penny_coin_shot.tscn")
var CoinShotNickel = preload("res://Coins/player_nickel_coin_shot.tscn")
var CoinShotDime = preload("res://Coins/player_dime_coin_shot.tscn")
var CoinShotQuarter = preload("res://Coins/player_quarter_coin_shot.tscn")

var DollarShotWashington = preload("res://Dollars/player_washington_dollar_shot.tscn")
var DollarShotLincoln = preload("res://Dollars/player_lincoln_dollar_shot.tscn")
var DollarShotJackson = preload("res://Dollars/player_jackson_dollar_shot.tscn")
var DollarShotGrant = preload("res://Dollars/player_grant_dollar_shot.tscn")

var CheckShot100 = preload("res://Checks/player_100_check_shot.tscn")
var CheckShot200 = preload("res://Checks/player_200_check_shot.tscn")
var CheckShot500 = preload("res://Checks/player_500_check_shot.tscn")
var CheckShot1000 = preload("res://Checks/player_1000_check_shot.tscn")

var Coin_Variant = Global_Variables.Coin_Variant
var coin_costs = [0.01, 0.05, 0.10, 0.25] # Determines the cost per shot of each coin

var Dollar_Variant = Global_Variables.Dollar_Variant
var dollar_costs = [1.0, 10.0, 20.0, 50.0]

var Check_Variant = Global_Variables.Check_Variant
var check_costs = [100.0, 200.0, 500.0, 1000.0]

enum ShotType {COIN, DOLLAR, CHECK}
var current_shot_type = ShotType.COIN  # Start with coin type as default

var is_firing = false
var fire_timer = 0.0

var money = Global_Variables.money

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		is_firing = event.pressed
		if event.pressed:
			attempt_fire()
	
	# Press E to cycle through the shot types (Coin, Dollar, Check)
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		cycle_shot_type()

func _process(delta):
	fire_timer += delta
	if is_firing:
		attempt_fire()

func attempt_fire():
	if money <= 0:
		return  # You can't shoot if you don't have money (but you should go bankrupt and lose before this occurs in the final product)

	var fire_rate = get_fire_rate()
	if fire_timer >= 1.0 / fire_rate:
		fire_shot()
		fire_timer = 0.0

func fire_shot():
	match current_shot_type:
		ShotType.COIN:
			var coin_type
			var cost = coin_costs[Coin_Variant]
			match Coin_Variant:
				0:
					coin_type = CoinShotPenny
				1:
					coin_type = CoinShotNickel
				2:
					coin_type = CoinShotDime
				3:
					coin_type = CoinShotQuarter
			_handle_coin_shot(coin_type, cost)
			
		ShotType.DOLLAR:
			var dollar_type
			var cost = dollar_costs[Dollar_Variant]
			match Dollar_Variant:
				0:
					dollar_type = DollarShotWashington
				1: 
					dollar_type = DollarShotLincoln
				2:
					dollar_type = DollarShotJackson
				3:
					dollar_type = DollarShotGrant
				
					
			_handle_dollar_shot(dollar_type, cost) 
			
			
		ShotType.CHECK:
			var check_type
			var cost = check_costs[Check_Variant]
			match Coin_Variant:
				0:
					check_type = CheckShot100
				1:
					check_type = CheckShot200
				2:
					check_type = CheckShot500
				3:
					check_type = CheckShot1000
			_handle_check_shot(check_type, cost)


func get_fire_rate():
	match current_shot_type:
		ShotType.COIN:
			return 8.0 
		ShotType.DOLLAR:
			return 3.0
		ShotType.CHECK:
			return 0.33

func _handle_coin_shot(coin_type, cost):
	if money >= cost:
		money -= cost
		var coin_instance = coin_type.instantiate()
		var parent = get_parent()
		
		var player_sprite = parent.get_node("Player_Sprite") # Shooting in relation to the player sprite location
		coin_instance.global_position = player_sprite.global_position
		
		var click_position = get_global_mouse_position()
		var direction = (click_position - player_sprite.global_position).normalized()
		
		coin_instance.rotation = direction.angle()
		coin_instance.set_initial_direction(direction)

		get_tree().current_scene.add_child(coin_instance)

func _handle_dollar_shot(dollar_type, cost):
	if money >= cost:
		money -= cost  # Ensure dollar_type is valid
		var dollar_instance = dollar_type.instantiate()  #
		var parent = get_parent()
		var player_sprite = parent.get_node("Player_Sprite")
		dollar_instance.global_position = player_sprite.global_position
		
		var click_position = get_global_mouse_position()
		var direction = (click_position - player_sprite.global_position).normalized()

		dollar_instance.rotation = direction.angle()
		dollar_instance.set_initial_direction(direction)

		get_tree().current_scene.add_child(dollar_instance)
			
func _handle_check_shot(check_type, cost):
	if money >= cost:
		money -= cost
		var check_instance = check_type.instantiate()
		var parent = get_parent()
		
		var player_sprite = parent.get_node("Player_Sprite") # Shooting in relation to the player sprite location
		check_instance.global_position = player_sprite.global_position
		
		var click_position = get_global_mouse_position()
		var direction = (click_position - player_sprite.global_position).normalized()
		
		check_instance.rotation = direction.angle()
		check_instance.set_initial_direction(direction)

		get_tree().current_scene.add_child(check_instance)

func cycle_shot_type():
	# Cycle through the shot types (Coin, Dollar, Check)
	current_shot_type = (current_shot_type + 1) % len(ShotType)