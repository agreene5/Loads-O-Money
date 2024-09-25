# Add variables that are needed by multiple scripts here (ex. Money)
extends Node

var deceleration = 5.0 # Defines deceleration of bullets over time (if you're using a rigidbody2D you can use the damp value under the Linear tab instead

var money = 10.0 # Defines the players money value (default value starts at $10)

var Coin_Variant = 3  # Determines the coin variant the user has | 0: Penny, 1: Nickel, 2: Dime, 3: Quarter
