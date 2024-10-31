extends Control

@onready var upgrade_menu = $"../UpgradeMenu"
@onready var CurrentCoinHealthLabel = $CurrentCoinHealth
@onready var UpgradedCoinHealthLabel =$UpgradedCoinHealth
@onready var CurrentCoinPriceLabel =$CurrentCoinPrice
@onready var UpgradedCoinPriceLabel =$UpgradedCoinPrice
@onready var CurrentBillHealthLabel =$CurrentBillHealth2
@onready var UpgradedBillHealthLabel =$UpgradedBillHealth2
@onready var CurrentBillPriceLabel =$CurrentBillPrice2
@onready var UpgradeBillPriceLabel =$UpgradedBillPrice2
@onready var CurrentCheckHealthLabel =$CurrentCheckHealth3
@onready var UpgradedCheckHealthLabel =$UpgradedCheckHealth3
@onready var CurrentCheckPriceLabel =$CurrentCheckPrice3
@onready var UpgradedCheckPriceLabel =$UpgradedCheckPrice3
@onready var CoinSprite = $Coin
@onready var BillSprite = $Bill
@onready var CheckSprite = $Check

var money =  Global_Variables.money
var CurrentCoinPrice = 1
var CurrentBillPrice = 10
var CurrentCheckPrice = 500
func _process(delta: float) -> void:
	pass





func _on_exit_button_pressed() -> void:
	upgrade_menu.hide()
	Engine.time_scale =1


func _on_upgrade_coin_button_pressed() -> void:
	if ((money >= CurrentCoinPrice) && (Global_Variables.Coin_Variant <3)):
		Global_Variables.Coin_Variant = Global_Variables.Coin_Variant + 1
		money = money - CurrentCoinPrice
		
		if (Global_Variables.Coin_Variant == 1):
			CurrentCoinPrice = 10
			$UpgradeCoinButton.text = "$" + str(CurrentCoinPrice) + "\n" + "Upgrade Coin"
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Nickel.png")
			CurrentCoinHealthLabel.text = "3 -> "
			UpgradedCoinHealthLabel.text = "8"
			CurrentCoinPriceLabel.text = "0.05 -> "
			UpgradedCoinPriceLabel.text = "0.10"
			CoinSprite.set_texture(texture)
		if(Global_Variables.Coin_Variant == 2):
			CurrentCoinPrice = 100
			$UpgradeCoinButton.text = "$" + str(CurrentCoinPrice) + "\n" + "Upgrade Coin"
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Dime.png")
			CoinSprite.set_texture(texture)
			CurrentCoinHealthLabel.text = "8 -> "
			UpgradedCoinHealthLabel.text = "20"
			CurrentCoinPriceLabel.text = "0.10 -> "
			UpgradedCoinPriceLabel.text = "0.25"
		if(Global_Variables.Coin_Variant == 3):
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Quarter.png")
			CoinSprite.set_texture(texture)
			$UpgradeCoinButton.text = "Fully Upgraded"
			CurrentCoinHealthLabel.text = "20"
			UpgradedCoinHealthLabel.text = ""
			CurrentCoinPriceLabel.text = "0.25"
			UpgradedCoinPriceLabel.text = ""
		
		
		
		
		
func _on_upgrade_bill_button_pressed() -> void:
	if (money >= CurrentBillPrice):
		money = money - CurrentBillPrice
		Global_Variables.Dollar_Variant = Global_Variables.Dollar_Variant + 1
		if (Global_Variables.Dollar_Variant == 1):
			CurrentBillPrice = 50
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Lincoln_5Dollar.PNG")
			$UpgradeBillButton.text = "$" + str(CurrentBillPrice) + "\n" + "Upgrade Bill"
			BillSprite.set_texture(texture)
			CurrentBillHealthLabel.text = "30 -> "
			UpgradedBillHealthLabel.text = "80"
			CurrentBillPriceLabel.text = "5 -> "
			UpgradeBillPriceLabel.text = "20"
			
		if(Global_Variables.Dollar_Variant == 2):
			CurrentBillPrice = 500
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Jackson_20Dollar.png")
			$UpgradeBillButton.text = "$" + str(CurrentBillPrice) + "\n" + "Upgrade Bill"
			BillSprite.set_texture(texture)
			CurrentBillHealthLabel.text = "80 -> "
			UpgradedBillHealthLabel.text = "200"
			CurrentBillPriceLabel.text = "20 -> "
			UpgradeBillPriceLabel.text = "50"
		if(Global_Variables.Dollar_Variant == 3):
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Grant_50Dollar.png")
			BillSprite.set_texture(texture)
			$UpgradeBillButton.text = "Fully Upgraded"
			CurrentBillHealthLabel.text = "200 -> "
			UpgradedBillHealthLabel.text = ""
			CurrentBillPriceLabel.text = "50 -> "
			UpgradeBillPriceLabel.text = ""


func _on_upgrade_check_button_pressed() -> void:
	if (money >= CurrentCheckPrice):
		Global_Variables.Check_Variant = Global_Variables.Check_Variant + 1
		if (Global_Variables.Check_Variant == 1):
			CurrentCheckPrice = 1000
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Check_200.png")
			$UpgradeCheckButton.text =  "$" + str(CurrentCheckPrice) + "\n" + "Upgrade Check"
			CheckSprite.set_texture(texture)
			CurrentCheckHealthLabel.text = "300 -> "
			UpgradedCheckHealthLabel.text = "800"
			CurrentCheckPriceLabel.text = "200 -> "
			UpgradedCheckPriceLabel.text = "500"
		if(Global_Variables.Check_Variant == 2):
			CurrentCheckPrice = 2000
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Check_500.PNG")
			$UpgradeCheckButton.text =  "$" + str(CurrentCheckPrice) + "\n" + "Upgrade Check"
			CheckSprite.set_texture(texture)
			CurrentCheckHealthLabel.text = "800 -> "
			UpgradedCheckHealthLabel.text = "2000"
			CurrentCheckPriceLabel.text = "500 -> "
			UpgradedCheckPriceLabel.text = "1000"
		if(Global_Variables.Check_Variant == 3):
			$UpgradeCheckButton.text =  "Fully Upgraded"
			var texture = load("res://Finished_Assets/Player_Shot_Assets/Check_1000.PNG")
			CheckSprite.set_texture(texture)
			CurrentCheckHealthLabel.text = "2000 -> "
			UpgradedCheckHealthLabel.text = ""
			CurrentCheckPriceLabel.text = "1000 -> "
			UpgradedCheckPriceLabel.text = ""
