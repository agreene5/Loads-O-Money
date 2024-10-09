# Add variables that are needed by multiple scripts here (ex. Money)
extends Node

var deceleration = 5.0 # Defines deceleration of bullets over time (if you're using a rigidbody2D you can use the damp value under the Linear tab instead

var money = 100000.0 # Defines the players money value (default value starts at $10)

signal Coin_Variant_changed
var Coin_Variant = 3  # Determines the coin variant the user has | 0: Penny, 1: Nickel, 2: Dime, 3: Quarter
func set_Coin_Variant(new_value):
		Coin_Variant = new_value
		emit_signal("Coin_Variant_changed")


var Dollar_Variant = 3 # Determines the dollar variant the user has | 0: Washington, 1: Lincoln, 2: Jackson, 3: Grant


signal Check_Variant_changed
var Check_Variant = 3 # Determines the check variant the user has | 0: $100 Check, 1: $200 Check, 2: $500 Check, 3: $1000 CHeck
func set_Check_Variant(new_value):
		Check_Variant = new_value
		emit_signal("Check_Variant_changed")


signal Current_Shot_changed
var Current_Shot = 0 # Determines what shot the player is currently using | 0: Coin, 1: Dollar, 2: Check
func set_Current_Shot(new_value):
		Current_Shot = new_value
		emit_signal("Current_Shot_changed")

# Shot health calculation function
