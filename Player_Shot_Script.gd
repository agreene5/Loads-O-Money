# This script defines the 3 shot types for the character, which are cycled through by pressing
# the "E" key.

extends Node2D

var CoinShot = preload("res://player_coin_shot.tscn")
# var DollarShot = preload("res://player_dollar_shot.tscn")
# var CheckShot = preload("res://player_check_shot.tscn")

enum ShotType {COIN, DOLLAR, CHECK}
var current_shot_type = ShotType.COIN # Default shot type

func _input(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				match current_shot_type:
						ShotType.COIN:
								_handle_coin_shot(event)
						ShotType.DOLLAR:
								_handle_dollar_shot(event)
						ShotType.CHECK:
								_handle_check_shot(event)
		
		# Press "E" in order to cycle through the shot types
		if event is InputEventKey and event.pressed and event.keycode == KEY_E:
				cycle_shot_type()

func _handle_coin_shot(event):
		var coin_instance = CoinShot.instantiate()
		var parent = get_parent()
		
		var player_sprite = parent.get_node("Player_Sprite")
		coin_instance.global_position = player_sprite.global_position
		
		var click_position = get_global_mouse_position()
		var direction = (click_position - player_sprite.global_position).normalized()
		
		coin_instance.rotation = direction.angle()
		
		coin_instance.set_initial_direction(direction)

		get_tree().current_scene.add_child(coin_instance)

func _handle_dollar_shot(event):
		# Code for dollar shot
		pass

func _handle_check_shot(event):
		# Code for check shot
		pass

# Function to cycle through shot types
func cycle_shot_type():
		match current_shot_type:
				ShotType.COIN:
						current_shot_type = ShotType.DOLLAR
				ShotType.DOLLAR:
						current_shot_type = ShotType.CHECK
				ShotType.CHECK:
						current_shot_type = ShotType.COIN
