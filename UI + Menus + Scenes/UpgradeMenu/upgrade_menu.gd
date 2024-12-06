extends Control
@onready var animation_player = $AnimationPlayer
@onready var upgrade_menu = $"../UpgradeMenu"
@onready var CurrentCoinHealthLabel = $Node2D/CurrentCoinHealth
@onready var UpgradedCoinHealthLabel =$Node2D/UpgradedCoinHealth
@onready var CurrentCoinPriceLabel =$Node2D/CurrentCoinPrice
@onready var UpgradedCoinPriceLabel =$Node2D/UpgradedCoinPrice
@onready var CurrentBillHealthLabel =$Node2D/CurrentBillHealth2
@onready var UpgradedBillHealthLabel =$Node2D/UpgradedBillHealth2
@onready var CurrentBillPriceLabel =$Node2D/CurrentBillPrice2
@onready var UpgradeBillPriceLabel =$Node2D/UpgradedBillPrice2
@onready var CurrentCheckHealthLabel =$Node2D/CurrentCheckHealth3
@onready var UpgradedCheckHealthLabel =$Node2D/UpgradedCheckHealth3
@onready var CurrentCheckPriceLabel =$Node2D/CurrentCheckPrice3
@onready var UpgradedCheckPriceLabel =$Node2D/UpgradedCheckPrice3
@onready var CoinSprite = $Node2D/Coin
@onready var BillSprite = $Node2D/Bill
@onready var CheckSprite = $Node2D/Check

var money =  Global_Variables.money
var CurrentCoinPrice = 5
var CurrentBillPrice = 20
var CurrentCheckPrice = 300

func _ready(): # Starting the values off with the Global Variable values
		get_tree().paused = true
		animation_player.play("fade_in_upgrade")
		
		# Check Coin Variant
		if (Global_Variables.Coin_Variant == 1):
				CurrentCoinPrice = 20
				$Node2D/UpgradeCoinButton.text = "$" + str(CurrentCoinPrice) + "\n" + "Upgrade Coin"
				var texture = load("res://Finished_Assets/Player_Shot_Assets/Nickel.png")
				CurrentCoinHealthLabel.text = "6 -> "
				UpgradedCoinHealthLabel.text = "9"
				CurrentCoinPriceLabel.text = "0.05 -> "
				UpgradedCoinPriceLabel.text = "0.1"
				CoinSprite.set_texture(texture)
		elif (Global_Variables.Coin_Variant == 2):
				CurrentCoinPrice = 200
				$Node2D/UpgradeCoinButton.text = "$" + str(CurrentCoinPrice) + "\n" + "Upgrade Coin"
				var texture = load("res://Finished_Assets/Player_Shot_Assets/Dime.png")
				CoinSprite.set_texture(texture)
				CurrentCoinHealthLabel.text = "9 -> "
				UpgradedCoinHealthLabel.text = "17.5"
				CurrentCoinPriceLabel.text = "0.1 -> "
				UpgradedCoinPriceLabel.text = "0.25"
		elif (Global_Variables.Coin_Variant == 3):
				var texture = load("res://Finished_Assets/Player_Shot_Assets/Quarter.png")
				CoinSprite.set_texture(texture)
				$Node2D/UpgradeCoinButton.text = "Fully Upgraded"
				CurrentCoinHealthLabel.text = "17.5"
				UpgradedCoinHealthLabel.text = ""
				CurrentCoinPriceLabel.text = "0.25"
				UpgradedCoinPriceLabel.text = ""

		# Check Dollar Variant
		if (Global_Variables.Dollar_Variant == 1):
				CurrentBillPrice = 200
				var texture = load("res://Finished_Assets/Player_Shot_Assets/Lincoln_5Dollar.PNG")
				$Node2D/UpgradeBillButton.text = "$" + str(CurrentBillPrice) + "\n" + "Upgrade Bill"
				BillSprite.set_texture(texture)
				CurrentBillHealthLabel.text = "180 -> "
				UpgradedBillHealthLabel.text = "500"
				CurrentBillPriceLabel.text = "5 -> "
				UpgradeBillPriceLabel.text = "20"
		elif (Global_Variables.Dollar_Variant == 2):
				CurrentBillPrice = 750
				var texture = load("res://Finished_Assets/Player_Shot_Assets/Jackson_20Dollar.png")
				$Node2D/UpgradeBillButton.text = "$" + str(CurrentBillPrice) + "\n" + "Upgrade Bill"
				BillSprite.set_texture(texture)
				CurrentBillHealthLabel.text = "500 -> "
				UpgradedBillHealthLabel.text = "1000"
				CurrentBillPriceLabel.text = "20 -> "
				UpgradeBillPriceLabel.text = "50"
		elif (Global_Variables.Dollar_Variant == 3):
				var texture = load("res://Finished_Assets/Player_Shot_Assets/Grant_50Dollar.png")
				BillSprite.set_texture(texture)
				$Node2D/UpgradeBillButton.text = "Fully Upgraded"
				CurrentBillHealthLabel.text = "1000"
				UpgradedBillHealthLabel.text = ""
				CurrentBillPriceLabel.text = "50"
				UpgradeBillPriceLabel.text = ""
		if (Global_Variables.Check_Variant == 1):
				CurrentCheckPrice = 750
				var texture = load("res://Finished_Assets/Player_Shot_Assets/Check_200.png")
				$Node2D/UpgradeCheckButton.text = "$" + str(CurrentCheckPrice) + "\n" + "Upgrade Check"
				CheckSprite.set_texture(texture)
				CurrentCheckHealthLabel.text = "2000 -> "
				UpgradedCheckHealthLabel.text = "4000"
				CurrentCheckPriceLabel.text = "200 -> "
				UpgradedCheckPriceLabel.text = "500"
		elif (Global_Variables.Check_Variant == 2):
				CurrentCheckPrice = 1500
				var texture = load("res://Finished_Assets/Player_Shot_Assets/Check_500.PNG")
				$Node2D/UpgradeCheckButton.text = "$" + str(CurrentCheckPrice) + "\n" + "Upgrade Check"
				CheckSprite.set_texture(texture)
				CurrentCheckHealthLabel.text = "4000 -> "
				UpgradedCheckHealthLabel.text = "7000"
				CurrentCheckPriceLabel.text = "500 -> "
				UpgradedCheckPriceLabel.text = "1000"
		elif (Global_Variables.Check_Variant == 3):
				var texture = load("res://Finished_Assets/Player_Shot_Assets/Check_1000.PNG")
				CheckSprite.set_texture(texture)
				$Node2D/UpgradeCheckButton.text = "Fully Upgraded"
				CurrentCheckHealthLabel.text = "7000"
				UpgradedCheckHealthLabel.text = ""
				CurrentCheckPriceLabel.text = "1000"
				UpgradedCheckPriceLabel.text = ""

func _on_exit_button_pressed() -> void:
	animation_player.play("fade_out_upgrade")
	get_parent().get_parent().unupgrading()
	await get_tree().create_timer(1.5).timeout
	get_tree().paused = false
	queue_free()


func _on_upgrade_coin_button_pressed() -> void:
	if ((Global_Variables.money >= CurrentCoinPrice) && (Global_Variables.Coin_Variant <3)):
		Global_Variables.Coin_Variant = Global_Variables.Coin_Variant + 1
		Global_Variables.money = Global_Variables.money - CurrentCoinPrice
		
		if (Global_Variables.Coin_Variant == 1):
			CurrentCoinPrice = 20
			$Node2D/UpgradeCoinButton.text = "$" + str(CurrentCoinPrice) + "\n" + "Upgrade Coin"
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Nickel.png")
			CurrentCoinHealthLabel.text = "6 -> "
			UpgradedCoinHealthLabel.text = "9"
			CurrentCoinPriceLabel.text = "0.05 -> "
			UpgradedCoinPriceLabel.text = "0.1"
			CoinSprite.set_texture(texture)
		if(Global_Variables.Coin_Variant == 2):
			CurrentCoinPrice = 200
			$Node2D/UpgradeCoinButton.text = "$" + str(CurrentCoinPrice) + "\n" + "Upgrade Coin"
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Dime.png")
			CoinSprite.set_texture(texture)
			CurrentCoinHealthLabel.text = "9 -> "
			UpgradedCoinHealthLabel.text = "17.5"
			CurrentCoinPriceLabel.text = "0.1 -> "
			UpgradedCoinPriceLabel.text = "0.25"
		if(Global_Variables.Coin_Variant == 3):
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Quarter.png")
			CoinSprite.set_texture(texture)
			$Node2D/UpgradeCoinButton.text = "Fully Upgraded"
			CurrentCoinHealthLabel.text = "17.5"
			UpgradedCoinHealthLabel.text = ""
			CurrentCoinPriceLabel.text = "0.25"
			UpgradedCoinPriceLabel.text = ""
	print(Global_Variables.Coin_Variant, " Coin Variant")
		
		
		
		
func _on_upgrade_bill_button_pressed() -> void:
	if (Global_Variables.money >= CurrentBillPrice):
		Global_Variables.money = Global_Variables.money - CurrentBillPrice
		Global_Variables.Dollar_Variant = Global_Variables.Dollar_Variant + 1
		if (Global_Variables.Dollar_Variant == 1):
			CurrentBillPrice = 200
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Lincoln_5Dollar.PNG")
			$Node2D/UpgradeBillButton.text = "$" + str(CurrentBillPrice) + "\n" + "Upgrade Bill"
			BillSprite.set_texture(texture)
			CurrentBillHealthLabel.text = "180 -> "
			UpgradedBillHealthLabel.text = "500"
			CurrentBillPriceLabel.text = "5 -> "
			UpgradeBillPriceLabel.text = "20"
			
		if(Global_Variables.Dollar_Variant == 2):
			CurrentBillPrice = 750
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Jackson_20Dollar.png")
			$Node2D/UpgradeBillButton.text = "$" + str(CurrentBillPrice) + "\n" + "Upgrade Bill"
			BillSprite.set_texture(texture)
			CurrentBillHealthLabel.text = "500 -> "
			UpgradedBillHealthLabel.text = "1000"
			CurrentBillPriceLabel.text = "20 -> "
			UpgradeBillPriceLabel.text = "50"
		if(Global_Variables.Dollar_Variant == 3):
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Grant_50Dollar.png")
			BillSprite.set_texture(texture)
			$Node2D/UpgradeBillButton.text = "Fully Upgraded"
			CurrentBillHealthLabel.text = "1000"
			UpgradedBillHealthLabel.text = ""
			CurrentBillPriceLabel.text = "50"
			UpgradeBillPriceLabel.text = ""


func _on_upgrade_check_button_pressed() -> void:
	if (Global_Variables.money >= CurrentCheckPrice):
		Global_Variables.money = Global_Variables.money - CurrentCheckPrice
		Global_Variables.Check_Variant = Global_Variables.Check_Variant + 1
		if (Global_Variables.Check_Variant == 1):
			CurrentCheckPrice = 1000
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Check_200.png")
			$Node2D/UpgradeCheckButton.text =  "$" + str(CurrentCheckPrice) + "\n" + "Upgrade Check"
			CheckSprite.set_texture(texture)
			CurrentCheckHealthLabel.text = "2000 -> "
			UpgradedCheckHealthLabel.text = "4000"
			CurrentCheckPriceLabel.text = "200 -> "
			UpgradedCheckPriceLabel.text = "500"
		if(Global_Variables.Check_Variant == 2):
			CurrentCheckPrice = 1500
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Check_500.PNG")
			$Node2D/UpgradeCheckButton.text =  "$" + str(CurrentCheckPrice) + "\n" + "Upgrade Check"
			CheckSprite.set_texture(texture)
			CurrentCheckHealthLabel.text = "4000 -> "
			UpgradedCheckHealthLabel.text = "7000"
			CurrentCheckPriceLabel.text = "500 -> "
			UpgradedCheckPriceLabel.text = "1000"
		if(Global_Variables.Check_Variant == 3):
			$Node2D/UpgradeCheckButton.text =  "Fully Upgraded"
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Check_1000.PNG")
			CheckSprite.set_texture(texture)
			CurrentCheckHealthLabel.text = "7000"
			UpgradedCheckHealthLabel.text = ""
			CurrentCheckPriceLabel.text = "1000"
			UpgradedCheckPriceLabel.text = ""
