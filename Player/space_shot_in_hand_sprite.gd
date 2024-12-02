extends Sprite2D

var penny_asset = preload("res://Finished_Assets/Player_In_Hand_Assets/Tiny_Penny.png")
var nickel_asset = preload("res://Finished_Assets/Player_In_Hand_Assets/Tiny_Nickel.png")
var dime_asset = preload("res://Finished_Assets/Player_In_Hand_Assets/Tiny_Dime.png")
var quarter_asset = preload("res://Finished_Assets/Player_In_Hand_Assets/Tiny_Quarter.png")

var money_gun_asset = preload("res://Finished_Assets/Player_In_Hand_Assets/Tiny_Moneygun.png")

var check100_asset = preload("res://Finished_Assets/Player_In_Hand_Assets/Tiny_100Check.png")
var check200_asset = preload("res://Finished_Assets/Player_In_Hand_Assets/Tiny_200Check.png")
var check500_asset = preload("res://Finished_Assets/Player_In_Hand_Assets/Tiny_500Check.png")
var check1000_asset = preload("res://Finished_Assets/Player_In_Hand_Assets/Tiny_1000Check.png")

func _ready():
	# These signals tell when the shot type or variant changes
	Global_Variables.connect("Current_Shot_changed", Callable(self, "_update_texture"))
	Global_Variables.connect("Coin_Variant_changed", Callable(self, "_update_texture"))
	Global_Variables.connect("Check_Variant_changed", Callable(self, "_update_texture"))

	_update_texture()

func _update_texture():
	match Global_Variables.Current_Shot:
		0:  # Coin
			match Global_Variables.Coin_Variant:
				0: texture = penny_asset
				1: texture = nickel_asset
				2: texture = dime_asset
				3: texture = quarter_asset
		1:  # Money Gun
			texture = money_gun_asset
		2:  # Check
			match Global_Variables.Check_Variant:
				0: texture = check100_asset
				1: texture = check200_asset
				2: texture = check500_asset
				3: texture = check1000_asset
