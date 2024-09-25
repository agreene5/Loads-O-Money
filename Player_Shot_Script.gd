# This script defines the 3 shot types for the character, which are cycled through by pressing
# the "E" key. It also subtracts from the money variable an amount determined by the shot type
# every time you shoot.

extends Node2D

var CoinShotPenny = preload("res://player_penny_coin_shot.tscn")
var CoinShotNickel = preload("res://player_nickel_coin_shot.tscn")
var CoinShotDime = preload("res://player_dime_coin_shot.tscn")
var CoinShotQuarter = preload("res://player_quarter_coin_shot.tscn")

# var DollarShotWashington = preload()
# var DollarShotLincoln = preload()
# var DollarShotJackson = preload()
# var DollarShotGrant = preload()

# var CheckShot100 = preload()
# var CheckShot200 = preload()
# var CheckShot500 = preload()
# var CheckShot1000 = preload()

var Coin_Variant = Global_Variables.Coin_Variant
var coin_costs = [0.01, 0.05, 0.10, 0.01] # Determines the cost per shot of each coin

#var Dollar_Variant
#var dollar_costs

#var Check_Variant
#var check_costs

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
			# 
			#
			#
			_handle_dollar_shot()
		ShotType.CHECK:
			#
			#
			#
			_handle_check_shot()

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

func _handle_dollar_shot():
	# Dollar shot code
	pass

func _handle_check_shot():
	# Check shot code
	pass

func cycle_shot_type():
	# Cycle through the shot types (Coin, Dollar, Check)
	current_shot_type = (current_shot_type + 1) % len(ShotType)
