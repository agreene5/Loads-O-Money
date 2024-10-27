extends Control

@onready var upgrade_menu = $"../UpgradeMenu"
@onready var CurrentCoinHealthLabel = $CurrentCoinHealth
@onready var UpgradedCoinHealthLabel = $UpgradedCoinHealth
@onready var CurrentCoinPriceLabel = $CurrentCoinPrice
@onready var CurrentBillHealthLabel = $CurrentBillHealth2
@onready var UpgradeBillHealthLabel = $UpgradedBillHealth2
@onready var CurrentBillPriceLabel = $CurrentBillPrice2
@onready var UpgradedBillPriceLabel = $UpgradedBillPrice2
@onready var CurrentCheckHealthLabel =$CurrentCheckHealth3
@onready var UpgradeCheckHealthLabel = $UpgradedCheckHealth3
@onready var CurrentCheckPrice =$CurrentCheckPrice3
@onready var UpgradedCheckPrice = $UpgradedCheckPrice3 
 

func _process(delta: float) -> void:
	pass





func _on_exit_button_pressed() -> void:
	upgrade_menu.hide()
	Engine.time_scale =1


func _on_upgrade_coin_button_pressed() -> void:
	pass


func _on_upgrade_bill_button_pressed() -> void:
	pass # Replace with function body.


func _on_upgrade_check_button_pressed() -> void:
	pass # Replace with function body.
